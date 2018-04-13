//
//  ColorExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/15/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

extension OSColor {
    public convenience init(_ color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }

    public convenience init(string: String) throws {
        self.init(try Color(string: string))
    }

    public static func toColor(osColor: OSColor) -> Color {
        return osColor.cgColor |> CGColor.toColor
    }

    public class func diagonalStripesPattern(color1: OSColor, color2: OSColor, isFlipped: Bool = false) -> OSColor {
        let bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
        let image = newImage(withSize: bounds.size, isOpaque: true, scale: mainScreenScale, renderingMode: .alwaysOriginal) { context in
            context.setFillColor(color1.cgColor)
            context.fill(bounds)
            let path = OSBezierPath()
            if isFlipped {
                path.addClosedPolygon(withPoints: [bounds.maxXmidY, bounds.maxXminY, bounds.midXminY])
                path.addClosedPolygon(withPoints: [bounds.maxXmaxY, bounds.minXminY, bounds.minXmidY, bounds.midXmaxY])
            } else {
                path.addClosedPolygon(withPoints: [bounds.midXminY, bounds.minXminY, bounds.minXmidY])
                path.addClosedPolygon(withPoints: [bounds.maxXminY, bounds.minXmaxY, bounds.midXmaxY, bounds.maxXmidY])
            }
            color2.set(); path.fill()
        }
        return OSColor(patternImage: image)
    }

    public func settingSaturation(saturation: CGFloat) -> OSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return OSColor(hue: h, saturation: saturation, brightness: b, alpha: a)
    }

    public func settingBrightness(brightness: CGFloat) -> OSColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return OSColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
}

extension OSColor {
    public var debugSummary: String {
        return (self |> OSColor.toColor).debugSummary
    }
}

extension OSColor {
    public static func testInitFromString() {
        do {
            let strings = [
                "#f80",
                "#ff8000",
                "0.1 0.5 1.0",
                "0.1 0.5 1.0 0.5",
                "r: 0.2 g: 0.4 b: 0.6",
                "red: 0.3 green: 0.5 blue: 0.7",
                "red: 0.3 green: 0.5 blue: 0.7 alpha: 0.5",
                "h: 0.2 s: 0.8 b: 1.0",
                "hue: 0.2 saturation: 0.8 brightness: 1.0",
                "hue: 0.2 saturation: 0.8 brightness: 1.0 alpha: 0.5"
                ]
            for string in strings {
                let color = try OSColor(string: string)
                print("string: \(string), color: \(color)")
            }
        } catch let error {
            logError(error)
        }
    }
}

public func ©=(lhs: inout OSColor?, rhs: Color?) {
    lhs = rhs?.osColor
}

public func ©=(lhs: inout OSColor, rhs: Color) {
    lhs = rhs.osColor
}

public func ©=(lhs: inout OSColor?, rhs: Color) {
    lhs = rhs.osColor
}

extension OSColor {
    public var luminance: Frac {
        return (self |> Color.init).luminance
    }

    public func multiplied(by rhs: Frac) -> OSColor {
        return Color(self).multiplied(by: rhs) |> OSColor.init
    }

    public func added(to rhs: OSColor) -> OSColor {
        return Color(self).added(to: Color(rhs)) |> OSColor.init
    }

    public func lightened(by frac: Frac) -> OSColor {
        return Color(self).lightened(by: frac) |> OSColor.init
    }

    public func darkened(by frac: Frac) -> OSColor {
        return Color(self).darkened(by: frac) |> OSColor.init
    }

    public func dodged(by frac: Frac) -> OSColor {
        return Color(self).dodged(by: frac) |> OSColor.init
    }

    public func burned(by frac: Frac) -> OSColor {
        return Color(self).burned(by: frac) |> OSColor.init
    }

}

extension OSColor {
    public static func oneColor(_ color: OSColor) -> ColorFunc {
        return makeOneColor(Color(color))
    }

    public static func twoColor(_ color1: OSColor, _ color2: OSColor) -> ColorFunc {
        return makeTwoColor(Color(color1), Color(color2))
    }

    public static func threeColor(_ color1: OSColor, _ color2: OSColor, _ color3: OSColor) -> ColorFunc {
        return makeThreeColor(Color(color1), Color(color2), Color(color3))
    }
}

extension Color {
    public init(cgColor: CGColor) {
        switch cgColor.colorSpace!.model {
        case .monochrome:
            let c = cgColor.components!
            let white = Double(c[0])
            let alpha = Double(c[1])
            self.init(white: white, alpha: alpha)
        case CGColorSpaceModel.rgb:
            let c = cgColor.components!
            let red = Double(c[0])
            let green = Double(c[1])
            let blue = Double(c[2])
            let alpha = Double(c[3])
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        default:
            fatalError("unsupported color model")
        }
    }

    public static func toCGColor(from color: Color) -> CGColor {
        let red = CGFloat(color.red)
        let green = CGFloat(color.green)
        let blue = CGFloat(color.blue)
        let alpha = CGFloat(color.alpha)

        return CGColor(colorSpace: sharedColorSpaceRGB, components: [red, green, blue, alpha])!
    }
}

extension CGColor {
    public static func toColor(from cgColor: CGColor) -> Color {
        return Color(cgColor: cgColor)
    }
}

extension Color {
    public init(_ color: OSColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: Frac(r), green: Frac(g), blue: Frac(b), alpha: Frac(a))
    }
}

extension Color {
    public var osColor: OSColor {
        return OSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    #if os(macOS)
    public var nsColor: NSColor {
        return osColor
    }
    #elseif !os(Linux)
    public var uiColor: UIColor {
        return osColor
    }
    #endif
}
