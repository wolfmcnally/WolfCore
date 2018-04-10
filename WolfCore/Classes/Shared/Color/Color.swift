//
//  Color.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/10/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

#if os(Linux)
    import Glibc
#endif

//public protocol ColorProtocol {
//    var luminance: Frac { get }
//    func multiplied(by rhs: Frac) -> Self
//    func added(to rhs: Self) -> Self
//    func lightened(by frac: Frac) -> Self
//    func darkened(by frac: Frac) -> Self
//    func dodged(by frac: Frac) -> Self
//    func burned(by frac: Frac) -> Self
//}

// rgb
// #rgb
//
// ^\s*#?(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\s*$
private let singleHexColorRegex = try! ~/"^\\s*#?(?<r>[[:xdigit:]])(?<g>[[:xdigit:]])(?<b>[[:xdigit:]])\\s*$"

// rrggbb
// #rrggbb
//
// ^\s*#?(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\s*$
private let doubleHexColorRegex = try! ~/"^\\s*#?(?<r>[[:xdigit:]]{2})(?<g>[[:xdigit:]]{2})(?<b>[[:xdigit:]]{2})\\s*$"

// 1 0 0
// 1 0 0 1
// 1.0 0.0 0.0
// 1.0 0.0 0.0 1.0
// .2 .3 .4 .5
//
// ^\s*(?<r>\d*(?:\.\d+)?)\s+(?<g>\d*(?:\.\d+)?)\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?<a>\d*(?:\.\d+)?))?\s*$
private let floatColorRegex = try! ~/"^\\s*(?<r>\\d*(?:\\.\\d+)?)\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?<a>\\d*(?:\\.\\d+)?))?\\s*$"

// r: .1 g: 0.512 b: 0.9
// r: .1 g: 0.512 b: 0.9 a: 1
// red: .1 green: 0.512 blue: 0.9
// red: .1 green: 0.512 blue: 0.9 alpha: 1
//
// ^\s*(?:r(?:ed)?):\s+(?<r>\d*(?:\.\d+)?)\s+(?:g(?:reen)?):\s+(?<g>\d*(?:\.\d+)?)\s+(?:b(?:lue)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
private let labeledColorRegex = try! ~/"^\\s*(?:r(?:ed)?):\\s+(?<r>\\d*(?:\\.\\d+)?)\\s+(?:g(?:reen)?):\\s+(?<g>\\d*(?:\\.\\d+)?)\\s+(?:b(?:lue)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?"

// h: .1 s: 0.512 b: 0.9
// hue: .1 saturation: 0.512 brightness: 0.9
// h: .1 s: 0.512 b: 0.9 alpha: 1
// hue: .1 saturation: 0.512 brightness: 0.9 alpha: 1.0
//
// ^\s*(?:h(?:ue)?):\s+(?<h>\d*(?:\.\d+)?)\s+(?:s(?:aturation)?):\s+(?<s>\d*(?:\.\d+)?)\s+(?:b(?:rightness)?):\s+(?<b>\d*(?:\.\d+)?)(?:\s+(?:a(?:lpha)?):\s+(?<a>\d*(?:\.\d+)?))?
private let labeledHSBColorRegex = try! ~/"^\\s*(?:h(?:ue)?):\\s+(?<h>\\d*(?:\\.\\d+)?)\\s+(?:s(?:aturation)?):\\s+(?<s>\\d*(?:\\.\\d+)?)\\s+(?:b(?:rightness)?):\\s+(?<b>\\d*(?:\\.\\d+)?)(?:\\s+(?:a(?:lpha)?):\\s+(?<a>\\d*(?:\\.\\d+)?))?"

public struct Color: Decodable {
    public var red: Frac
    public var green: Frac
    public var blue: Frac
    public var alpha: Frac

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        try self.init(string: stringValue)
    }

    public init(red: Frac, green: Frac, blue: Frac, alpha: Frac = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(redByte: UInt8, greenByte: UInt8, blueByte: UInt8, alphaByte: UInt8 = 255) {
        self.init(red: Double(redByte) / 255.0,
                  green: Double(greenByte) / 255.0,
                  blue: Double(blueByte) / 255.0,
                  alpha: Double(alphaByte) / 255.0
        )
    }

    public init(white: Frac, alpha: Frac = 1.0) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }

    public init(data: Data) {
        let r = data[0]
        let g = data[1]
        let b = data[2]
        let a = data.count >= 4 ? data[3] : 255
        self.init(redByte: r, greenByte: g, blueByte: b, alphaByte: a)
    }

    public init(color: Color, alpha: Frac) {
        self.red = color.red
        self.green = color.green
        self.blue = color.blue
        self.alpha = alpha
    }

    public init(hue h: Frac, saturation s: Frac, brightness v: Frac, alpha a: Frac = 1.0) {
        let v = v.clamped()
        let s = s.clamped()
        alpha = a
        if s <= 0.0 {
            red = v
            green = v
            blue = v
        } else {
            var h = h.truncatingRemainder(dividingBy: 1.0)
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floor(h))
            let f = h - Double(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch i {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: red = 0; green = 0; blue = 0; assert(false, "unknown hue sector")
            }
        }
    }

    private static func components(forSingleHexStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            let i = try string |> Hex.init |> UInt8.init
            components[index] = Double(i) / 15.0
        }
    }

    private static func components(forDoubleHexStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            let i = try string |> Hex.init |> UInt8.init
            components[index] = Double(i) / 255.0
        }
    }

    private static func components(forFloatStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    private static func components(forLabeledStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    private static func components(forLabeledHSBStrings strings: [String], components: inout [Double]) throws {
        for (index, string) in strings.enumerated() {
            if let f = Double(string) {
                components[index] = Double(f)
            }
        }
    }

    public init(string s: String) throws {
        var components: [Double] = [0.0, 0.0, 0.0, 1.0]
        var isHSB = false

        if let strings = singleHexColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forSingleHexStrings: strings, components: &components)
        } else if let strings = doubleHexColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forDoubleHexStrings: strings, components: &components)
        } else if let strings = floatColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forFloatStrings: strings, components: &components)
        } else if let strings = labeledColorRegex.matchedSubstrings(inString: s) {
            try type(of: self).components(forLabeledStrings: strings, components: &components)
        } else if let strings = labeledHSBColorRegex.matchedSubstrings(inString: s) {
            isHSB = true
            try type(of: self).components(forLabeledHSBStrings: strings, components: &components)
        } else {
            throw ValidationError(message: "Could not parse color from string: \(s)", violation: "colorStringFormat")
        }

        if isHSB {
            self.init(hue: components[0], saturation: components[1], brightness: components[2], alpha: components[3])
        } else {
            self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        }
    }

    public static func random(random: Random = Random.shared, alpha: Frac = 1.0) -> Color {
        return Color(
            red: random.number(),
            green: random.number(),
            blue: random.number(),
            alpha: alpha
        )
    }

    // NOTE: Not gamma-corrected
    public var luminance: Frac {
        return red * 0.2126 + green * 0.7152 + blue * 0.0722
    }

    public func withAlphaComponent(_ alpha: Frac) -> Color {
        return Color(color: self, alpha: alpha)
    }

    public func multiplied(by rhs: Frac) -> Color {
        return Color(red: red * rhs, green: green * rhs, blue: blue * rhs, alpha: alpha)
    }

    public func added(to rhs: Color) -> Color {
        return Color(red: red + rhs.red, green: green + rhs.green, blue: blue + rhs.blue, alpha: alpha)
    }

    public func lightened(by frac: Frac) -> Color {
        return Color(
            red: frac.lerpedFromFrac(to: red..1),
            green: frac.lerpedFromFrac(to: green..1),
            blue: frac.lerpedFromFrac(to: blue..1),
            alpha: alpha)
    }

    public static func lightened(by frac: Frac) -> (Color) -> Color {
        return { $0.lightened(by: frac) }
    }

    public func darkened(by frac: Frac) -> Color {
        return Color(
            red: frac.lerpedFromFrac(to: red..0),
            green: frac.lerpedFromFrac(to: green..0),
            blue: frac.lerpedFromFrac(to: blue..0),
            alpha: alpha)
    }

    public static func darkened(by frac: Frac) -> (Color) -> Color {
        return { $0.darkened(by: frac) }
    }

    /// Identity fraction is 0.0
    public func dodged(by frac: Frac) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(red / f, 1.0),
            green: min(green / f, 1.0),
            blue: min(blue / f, 1.0),
            alpha: alpha)
    }

    public static func dodged(by frac: Frac) -> (Color) -> Color {
        return { $0.dodged(by: frac) }
    }

    /// Identity fraction is 0.0
    public func burned(by frac: Frac) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(1.0 - (1.0 - red) / f, 1.0),
            green: min(1.0 - (1.0 - green) / f, 1.0),
            blue: min(1.0 - (1.0 - blue) / f, 1.0),
            alpha: alpha)
    }

    public static func burned(by frac: Frac) -> (Color) -> Color {
        return { $0.burned(by: frac) }
    }

    public static let black = Color(red: 0, green: 0, blue: 0, alpha: 1)
    public static let darkGray = Color(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    public static let lightGray = Color(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
    public static let white = Color(red: 1, green: 1, blue: 1, alpha: 1)
    public static let gray = Color(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    public static let red = Color(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green = Color(red: 0, green: 1, blue: 0, alpha: 1)
    public static let darkGreen = Color(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    public static let blue = Color(red: 0, green: 0, blue: 1, alpha: 1)
    public static let cyan = Color(red: 0, green: 1, blue: 1, alpha: 1)
    public static let yellow = Color(red: 1, green: 1, blue: 0, alpha: 1)
    public static let magenta = Color(red: 1, green: 0, blue: 1, alpha: 1)
    public static let orange = Color(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    public static let purple = Color(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    public static let brown = Color(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    public static let clear = Color(red: 0, green: 0, blue: 0, alpha: 0)
    public static let pink = Color(red: 1, green: 0.75294118, blue: 0.79607843)

    public static let chartreuse = WolfCore.blend(from: .yellow, to: .green, at: 0.5)
    public static let gold = Color(redByte: 251, greenByte: 212, blueByte: 55)
    public static let blueGreen = Color(redByte: 0, greenByte: 169, blueByte: 149)
    public static let mediumBlue = Color(redByte: 0, greenByte: 110, blueByte: 185)
    public static let deepBlue = Color(redByte: 60, greenByte: 55, blueByte: 149)
}

extension Color: Equatable { }

public func == (left: Color, right: Color) -> Bool {
    return left.red == right.red &&
        left.green == right.green &&
        left.blue == right.blue &&
        left.alpha == right.alpha
}

extension Color: CustomStringConvertible {
    public var description: String {
        return "Color(\(debugSummary))"
    }
}

extension Color {
    public var debugSummary: String {
        let joiner = Joiner(left: "(", right: ")")
        var needAlpha = true
        switch (red, green, blue, alpha) {
        case (0, 0, 0, 0):
            joiner.append("clear")
            needAlpha = false
        case (0, 0, 0, _):
            joiner.append("black")
        case (1, 1, 1, _):
            joiner.append("white")
        case (0.5, 0.5, 0.5, _):
            joiner.append("gray")
        case (1, 0, 0, _):
            joiner.append("red")
        case (0, 1, 0, _):
            joiner.append("green")
        case (0, 0, 1, _):
            joiner.append("blue")
        case (0, 1, 1, _):
            joiner.append("cyan")
        case (1, 0, 1, _):
            joiner.append("magenta")
        case (1, 1, 0, _):
            joiner.append("yellow")
        default:
            joiner.append("r:\(red %% 2) g:\(green %% 2) b:\(blue %% 2)")
        }
        if needAlpha && alpha < 1.0 {
            joiner.append("a: \(alpha %% 2)")
        }
        return joiner.description
    }
}

public func * (lhs: Color, rhs: Frac) -> Color {
    return lhs.multiplied(by: rhs)
}

public func + (lhs: Color, rhs: Color) -> Color {
    return lhs.added(to: rhs)
}

extension Color {
    public func blend(to color: Color, at frac: Frac) -> Color {
        return WolfCore.blend(from: self, to: color, at: frac)
    }
}
