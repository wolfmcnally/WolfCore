//
//  ImageUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/2/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

import WolfBase

#if os(macOS)
    public func newImage(withSize size: Size, isOpaque: Bool = false, background: NSColor? = nil, scale: CGFloat = 0.0, isFlipped: Bool = true, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock? = nil) -> NSImage {
        return newImage(withSize: size.cgSize, isOpaque: isOpaque, background: background, scale: scale, isFlipped: isFlipped, renderingMode: renderingMode, drawing: drawing)
    }

    public func newImage(withSize size: CGSize, isOpaque: Bool = false, background: NSColor? = nil, scale: CGFloat = 0.0, isFlipped: Bool = true, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock? = nil) -> NSImage {
        let image = NSImage.init(size: size)

        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
                                        pixelsWide: Int(size.width),
                                        pixelsHigh: Int(size.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: isOpaque ? 3 : 4,
                                        hasAlpha: !isOpaque,
                                        isPlanar: false,
                                        colorSpaceName: NSColorSpaceName.calibratedRGB,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)

        image.addRepresentation(rep!)
        image.lockFocus()

        let bounds = CGRect(origin: .zero, size: size)
        let nsContext = NSGraphicsContext.current!
        let context = nsContext.cgContext

        drawInto(context) { context in
            if isOpaque {
                context.setFillColor(background?.cgColor ?? OSColor.black.cgColor)
                context.fill(bounds)
            } else {
                context.clear(bounds)
                if let background = background {
                    context.setFillColor(background.cgColor)
                    context.fill(bounds)
                }
            }
        }

        if let drawing = drawing {
            drawInto(context, isFlipped: isFlipped, bounds: bounds) { context in
                drawing(context)
            }
        }

        image.unlockFocus()
        return image
    }
#else
    public func newImage(withSize size: Size, isOpaque: Bool = false, background: UIColor? = nil, scale: CGFloat = 0.0, isFlipped: Bool = false, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock? = nil) -> UIImage {
        return newImage(withSize: size.cgSize, isOpaque: isOpaque, background: background, scale: scale, isFlipped: isFlipped, renderingMode: renderingMode, drawing: drawing)
    }

    public func newImage(withSize size: CGSize, isOpaque: Bool = false, background: UIColor? = nil, scale: CGFloat = 0.0, isFlipped: Bool = false, renderingMode: OSImageRenderingMode = .automatic, drawing: CGContextBlock? = nil) -> UIImage {
        guard size.width > 0 && size.height > 0 else {
            fatalError("Size may not be empty.")
        }
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale)
        let context = currentGraphicsContext

        let bounds = CGRect(origin: .zero, size: size)

        if let background = background {
            drawInto(context) { context in
                context.setFillColor(background.cgColor)
                context.fill(bounds)
            }
        }

        if let drawing = drawing {
            drawInto(context, isFlipped: isFlipped, bounds: bounds) { context in
                drawing(context)
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(renderingMode)
        UIGraphicsEndImageContext()

        return image
    }
#endif
