
//
//  CGColorUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/10/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

import CoreGraphics

public var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
public var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
public var sharedWhiteColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(1.0), CGFloat(1.0)])
public var sharedBlackColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(1.0)])
public var sharedClearColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(0.0)])

extension CGColor {
    public func toRGB() -> CGColor {
        switch colorSpace!.model {
        case CGColorSpaceModel.monochrome:
            let c = components!
            let gray = c[0]
            let a = c[1]
            return CGColor(colorSpace: sharedColorSpaceRGB, components: [gray, gray, gray, a])!
        case CGColorSpaceModel.rgb:
            return self
        default:
            fatalError("unsupported color model")
        }
    }
}

extension CGGradient {
    public static func new(with gradient: ColorFracGradient) -> CGGradient {
        var cgColors = [CGColor]()
        var locations = [CGFloat]()
        for colorFrac in gradient.colorFracs {
            cgColors.append(colorFrac.color.cgColor)
            locations.append(CGFloat(colorFrac.frac))
        }
        return CGGradient(colorsSpace: sharedColorSpaceRGB, colors: cgColors as CFArray, locations: locations)!
    }

    public static func new(from color1: Color, to color2: Color) -> CGGradient {
        return new(with: ColorFracGradient([ColorFrac(color1, 0.0), ColorFrac(color2, 1.0)]))
    }

    public static func new(from color1: OSColor, to color2: OSColor) -> CGGradient {
        return new(from: color1 |> Color.init, to: color2 |> Color.init)
    }
}

extension Color {
    public var cgColor: CGColor {
        return CGColor(colorSpace: sharedColorSpaceRGB, components: [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)])!
    }
}
