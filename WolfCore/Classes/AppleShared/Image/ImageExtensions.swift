//
//  ImageExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/3/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import WolfPipe
import WolfNumerics

extension OSImage {
    public var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}

extension OSImage {
    public func newMask() -> CGImage {
        let cgImage = self.cgImage!
        return CGImage(
            maskWidth: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: cgImage.bitsPerComponent,
            bitsPerPixel: cgImage.bitsPerPixel,
            bytesPerRow: cgImage.bytesPerRow,
            provider: cgImage.dataProvider!,
            decode: nil,
            shouldInterpolate: false)!
    }
}

#if !os(macOS)
    extension OSImage {
        public struct Name: ExtensibleEnumeratedName {
            public let rawValue: String

            public init(_ rawValue: String) {
                self.rawValue = rawValue
            }

            // RawRepresentable
            public init(rawValue: String) { self.init(rawValue) }
        }

        public convenience init?(named name: Name) {
            self.init(named: name.rawValue)
        }
    }
#endif

#if os(macOS)
    extension OSImage {
        public convenience init?(named name: String, in bundle: Bundle?) {
            let bundle = bundle ?? Bundle.main
            guard let image = bundle.image(forResource: name) else {
                return nil
            }
            guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                return nil
            }
            self.init(cgImage: cgImage, size: image.size)
        }
    }
#elseif os(watchOS)
    extension OSImage {
        public convenience init?(named name: String, in bundle: Bundle?) {
            self.init(named: name)
        }
    }
#else
    extension OSImage {
        public convenience init?(named name: String, in bundle: Bundle?) {
            self.init(named: name, in: bundle, compatibleWith: nil)
        }
    }
#endif

#if !os(watchOS)
    import CoreImage
    extension OSImage {
        public func desaturated(saturation: Double = 0.0, brightness: Double = 0.0, contrast: Double = 1.1, exposureAdjust: Double = 0.7) -> OSImage {
            return self
                |> ColorControlsFilter(saturation: saturation, brightness: brightness, contrast: contrast)
                |> ExposureAdjustFilter(ev: exposureAdjust)
                |> (imageOrientation, self.scale)
        }

        public func blurred(radius: Double = 5.0) -> OSImage {
            return self
                |> BlurFilter(radius: radius)
                |> (imageOrientation, self.scale)
        }
    }
#endif

extension OSImage {
    public func tinted(withColor color: OSColor) -> OSImage {
        return newImage(withSize: self.size, isOpaque: false, scale: self.scale, renderingMode: .alwaysOriginal) { context in
            self.draw(in: self.bounds)
            context.setFillColor(color.cgColor)
            context.setBlendMode(.sourceIn)
            context.fill(self.bounds)
        }
    }

    public func shaded(withColor color: OSColor, blendMode: CGBlendMode = .multiply) -> OSImage {
        return newImage(withSize: size, isOpaque: false, scale: scale, isFlipped: true, renderingMode: .alwaysOriginal) { context in
            drawInto(context) { context in
                context.clip(to: self.bounds, mask: self.cgImage!)
                context.setFillColor(color.cgColor)
                context.fill(self.bounds)
            }
            context.setBlendMode(blendMode)
            context.draw(self.cgImage!, in: self.bounds)
        }
    }

    public func dodged(withColor color: OSColor) -> OSImage {
        return shaded(withColor: color, blendMode: .colorDodge)
    }

    public convenience init(size: CGSize, color: OSColor, isOpaque: Bool = false, scale: CGFloat = 0.0) {
        let image = newImage(withSize: size, isOpaque: isOpaque, scale: scale, renderingMode: .alwaysOriginal) { context in
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
        #if os(macOS)
            self.init(cgImage: image.cgImage!, size: image.size)
        #else
            self.init(cgImage: image.cgImage!, scale: scale, orientation: .up)
        #endif
    }

    public func composited(over backgroundImage: OSImage) -> OSImage {
        let backgroundBounds = CGRect(origin: .zero, size: backgroundImage.size)
        let foregroundBounds = CGRect(origin: .zero, size: self.size)

        return newImage(withSize: backgroundBounds.size, isOpaque: false, scale: backgroundImage.scale, renderingMode: .alwaysOriginal) { _ in
            backgroundImage.draw(in: backgroundBounds)
            self.draw(in: foregroundBounds)
        }
    }

    public func masked(with path: OSBezierPath) -> OSImage {
        return newImage(withSize: size, isOpaque: false, scale: scale, renderingMode: renderingMode) { context in
            context.addPath(path.cgPath)
            context.clip()
            self.draw(in: self.bounds)
        }
    }

    public func maskedWithCircle() -> OSImage {
        return masked(with: OSBezierPath(ovalIn: bounds))
    }

    public func scaled(toSize size: CGSize, isOpaque: Bool = false, interpolationQuality: CGInterpolationQuality = .`default`) -> OSImage {
        let targetSize = self.size.aspectFit(within: size)
        return newImage(withSize: targetSize, isOpaque: isOpaque, scale: scale, renderingMode: self.renderingMode) { context in
            context.interpolationQuality = interpolationQuality
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    public func cropped(toRect rect: CGRect, isOpaque: Bool = false) -> OSImage {
        return newImage(withSize: rect.size, isOpaque: isOpaque, scale: scale, renderingMode: self.renderingMode) { _ in
            self.draw(in: CGRect(x: -rect.minX, y: -rect.minY, width: rect.width, height: rect.height))
        }
    }

    public func scaledDownAndCroppedToSquare(withMaxSize maxSize: CGFloat) -> OSImage {
        let scale = min(size.scaleForAspectFill(within: CGSize(width: maxSize, height: maxSize)), 1.0)
        let scaledImage: OSImage
        if scale < 1.0 {
            let scaledSize = CGSize(vector: CGVector(size: size) * scale)
            scaledImage = scaled(toSize: scaledSize)
        } else {
            scaledImage = self
        }

        let length = min(scaledImage.size.width, scaledImage.size.height)
        let croppedSize = CGSize(width: length, height: length)
        let croppedImage: OSImage
        if croppedSize != scaledImage.size {
            let cropRect = CGRect(origin: .zero, size: croppedSize).settingMidXmidY(scaledImage.bounds.midXmidY)
            croppedImage = scaledImage.cropped(toRect: cropRect)
        } else {
            croppedImage = scaledImage
        }
        return croppedImage
    }
}

extension OSImage {
    private static func newPulseFrameImage(size: CGSize, color: Color, cycles: Double, holdUntil: Frac, fadeAt: Frac, phase: Frac) -> OSImage {
        return newImage(withSize: size) { context in
            let center = size.bounds.midXmidY
            let radius = min(size.width, size.height) / 2
            let baseAlpha = color.alpha
            let shading = Shading(start: center, startRadius: 0, end: center, endRadius: radius) { frac in
                guard frac > holdUntil else { return color }

                let phasedAlpha = (easeIn(frac) * cycles + (1 - phase)).truncatingRemainder(dividingBy: 1)
                let fadeAlpha: Double
                if frac <= fadeAt {
                    fadeAlpha = 1
                } else {
                    fadeAlpha = 1 - easeIn(frac.lerpedToFrac(from: fadeAt .. 1))
                }
                return color.withAlphaComponent(baseAlpha * phasedAlpha * fadeAlpha)
            }
            context.drawShading(shading)
        }
    }

    #if !os(macOS)
    public static func newAnimatedPulseImage(size: CGSize, color: Color, cycles: Double = 1, holdUntil: Frac = 0, fadeAt: Frac, frames: Int, duration: TimeInterval) -> OSImage {
        var images = [OSImage]()
        for frame in 0 ..< frames {
            let phase: Frac = Double(frame).lerpedToFrac(from: 0 .. Double(frames))
            images.append(newPulseFrameImage(size: size, color: color, cycles: cycles, holdUntil: holdUntil, fadeAt: fadeAt, phase: phase))
        }
        return OSImage.animatedImage(with: images, duration: duration)!
    }
    #endif
}

public struct ImageReference: ExtensibleEnumeratedName, Reference {
    public let rawValue: String
    public let bundle: Bundle

    public init(_ rawValue: String, inBundle bundle: Bundle? = nil) {
        self.rawValue = rawValue
        self.bundle = bundle ?? Bundle.main
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }

    // Reference
    public var referent: OSImage {
        return OSImage(named: rawValue, in: bundle)!
    }
}

public postfix func ® (lhs: ImageReference) -> OSImage {
    return lhs.referent
}
