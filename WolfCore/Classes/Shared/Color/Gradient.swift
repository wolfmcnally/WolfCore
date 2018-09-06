//
//  Gradient.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/10/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import WolfNumerics

public struct ColorFrac: Equatable {
    public let color: Color
    public let frac: Double

    public init(_ color: Color, _ frac: Frac) {
        self.color = color
        self.frac = frac
    }

    public static func == (lhs: ColorFrac, rhs: ColorFrac) -> Bool {
        return lhs.color == rhs.color && lhs.frac == rhs.frac
    }
}

public struct ColorFracHandle: Equatable {
    public let color: Color
    public let frac: Double
    public let handle: Double

    public init(_ color: Color, _ frac: Frac, _ handle: Double) {
        self.color = color
        self.frac = frac
        self.handle = handle
    }

    public static func == (lhs: ColorFracHandle, rhs: ColorFracHandle) -> Bool {
        return lhs.color == rhs.color && lhs.frac == rhs.frac && lhs.handle == rhs.handle
    }
}

public struct ColorFracGradient: Equatable {
    public let colorFracs: [ColorFrac]

    public init(_ colorFracs: [ColorFrac]) {
        self.colorFracs = colorFracs
    }

    public static func == (lhs: ColorFracGradient, rhs: ColorFracGradient) -> Bool {
        return lhs.colorFracs == rhs.colorFracs
    }
}

public struct ColorFracHandleGradient: Equatable {
    public let colorFracHandles: [ColorFracHandle]

    public init(_ colorFracHandles: [ColorFracHandle]) {
        self.colorFracHandles = colorFracHandles
    }

    public static func == (lhs: ColorFracHandleGradient, rhs: ColorFracHandleGradient) -> Bool {
        return lhs.colorFracHandles == rhs.colorFracHandles
    }
}

public struct Gradient {

    public static let grayscale = blend(from: .black, to: .white)

    // Color Harmonies, Analogous
    public static let goldRedOrange = makeThreeColor(.gold, .red, .orange)
    public static let bluegreenBlueGreen = makeThreeColor(.blueGreen, .mediumBlue, .darkGreen)
    public static let blueMagentaRed = makeThreeColor(.deepBlue, .magenta, .red)
    public static let yellowGoldGreen = makeThreeColor(.yellow, .gold, .darkGreen)
    public static let chartreuseYellowGreen = makeThreeColor(.chartreuse, .yellow, .darkGreen)

    // Color Harmonies, Primary Complementary
    public static let orangeMediumblue = makeTwoColor(.orange, .mediumBlue)
    public static let purpleGold = makeTwoColor(.purple, .gold)
    public static let redGreen = makeTwoColor(.red, .darkGreen)

    // Color Harmonies, Secondary Complementary
    public static let chartreusePurple = makeTwoColor(.chartreuse, .purple)
    public static let greenOrange = makeTwoColor(.darkGreen, .orange)
    public static let deepblueOrange = makeTwoColor(.deepBlue, .orange)

    // Color Harmonies, Split Complementary
    public static let bluePurpleOrange = makeThreeColor(.mediumBlue, .purple, .orange)
    public static let yellowBluePurple = makeThreeColor(.yellow, .mediumBlue, .purple)
    public static let chartreuseBlueRed = makeThreeColor(.chartreuse, .deepBlue, .red)
    public static let greenMagentaOrange = makeThreeColor(.darkGreen, .magenta, .orange)
    public static let bluegreenRedOrange = makeThreeColor(.blueGreen, .red, .orange)
    public static let orangeBlueOrange = makeThreeColor(.orange, .mediumBlue, .orange)
    public static let goldPurpleOrange = makeThreeColor(.gold, .purple, .orange)
    public static let chartreuseBlueOrange = makeThreeColor(.chartreuse, .deepBlue, .orange)

    // Earth Tones
    public static let coffee = makeThreeColor(
        Color(redByte: 250, greenByte: 243, blueByte: 232),
        Color(redByte: 199, greenByte: 152, blueByte: 60),
        Color(redByte: 191, greenByte: 124, blueByte: 38))
    public static let valentine = makeThreeColor(
        Color(redByte: 240, greenByte: 222, blueByte: 215),
        Color(redByte: 178, greenByte: 85, blueByte: 56),
        Color(redByte: 189, greenByte: 49, blueByte: 26))
    public static let strata1 = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 184, greenByte: 94, blueByte: 66), 0.00, 0.50),
        ColorFracHandle(Color(redByte: 232, greenByte: 186, blueByte: 128), 0.25, 0.82),
        ColorFracHandle(Color(redByte: 159, greenByte: 34, blueByte: 20), 0.46, 0.50),
        ColorFracHandle(Color(redByte: 196, greenByte: 120, blueByte: 105), 0.56, 0.50),
        ColorFracHandle(Color(redByte: 113, greenByte: 55, blueByte: 31), 0.70, 0.50),
        ColorFracHandle(Color(redByte: 244, greenByte: 187, blueByte: 58), 1.00, 0.50)
        ])
    public static let strata2 = blend(colorFracs: [
        ColorFrac(Color(redByte: 0, greenByte: 89, blueByte: 92), 0.00),
        ColorFrac(Color(redByte: 166, greenByte: 184, blueByte: 194), 0.25),
        ColorFrac(Color(redByte: 168, greenByte: 163, blueByte: 155), 0.46),
        ColorFrac(Color(redByte: 46, greenByte: 52, blueByte: 24), 0.56),
        ColorFrac(Color(redByte: 106, greenByte: 121, blueByte: 137), 0.70),
        ColorFrac(Color(redByte: 215, greenByte: 222, blueByte: 226), 1.00)
        ])
    public static let strata3 = blend(colorFracs: [
        ColorFrac(Color(redByte: 51, greenByte: 63, blueByte: 41), 0.00),
        ColorFrac(Color(redByte: 192, greenByte: 152, blueByte: 18), 0.26),
        ColorFrac(Color(redByte: 176, greenByte: 127, blueByte: 32), 0.35),
        ColorFrac(Color(redByte: 102, greenByte: 107, blueByte: 67), 0.67),
        ColorFrac(Color(redByte: 110, greenByte: 79, blueByte: 14), 0.70),
        ColorFrac(Color(redByte: 135, greenByte: 119, blueByte: 116), 1.00)
        ])

    // Seasons
    public static let spring = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 172, greenByte: 202, blueByte: 234), 0.00, 0.50),
        ColorFracHandle(Color(redByte: 207, greenByte: 194, blueByte: 223), 0.22, 0.50),
        ColorFracHandle(Color(redByte: 249, greenByte: 234, blueByte: 191), 0.43, 0.82),
        ColorFracHandle(Color(redByte: 227, greenByte: 185, blueByte: 215), 0.72, 0.87),
        ColorFracHandle(Color(redByte: 172, greenByte: 202, blueByte: 234), 0.74, 0.50),
        ColorFracHandle(Color(redByte: 201, greenByte: 230, blueByte: 209), 1.00, 0.50)
        ])
    public static let summer = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 240, greenByte: 200, blueByte: 59), 0.11, 0.50),
        ColorFracHandle(Color(redByte: 241, greenByte: 86, blueByte: 60), 0.24, 0.40),
        ColorFracHandle(Color(redByte: 195, greenByte: 75, blueByte: 155), 0.39, 0.50),
        ColorFracHandle(Color(redByte: 0, greenByte: 179, blueByte: 193), 0.79, 0.50),
        ColorFracHandle(Color(redByte: 0, greenByte: 179, blueByte: 108), 0.81, 0.50),
        ColorFracHandle(Color(redByte: 0, greenByte: 179, blueByte: 193), 1.00, 0.50)
        ])
    public static let autumn = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 118, greenByte: 114, blueByte: 62), 0.00, 0.42),
        ColorFracHandle(Color(redByte: 220, greenByte: 115, blueByte: 84), 0.24, 0.40),
        ColorFracHandle(Color(redByte: 255, greenByte: 205, blueByte: 3), 0.69, 0.50),
        ColorFracHandle(Color(redByte: 220, greenByte: 115, blueByte: 84), 0.81, 0.50),
        ColorFracHandle(Color(redByte: 148, greenByte: 46, blueByte: 64), 1.00, 0.50)
        ])
    public static let winter = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 177, greenByte: 199, blueByte: 215), 0.00, 0.50),
        ColorFracHandle(Color(redByte: 213, greenByte: 217, blueByte: 227), 0.26, 0.50),
        ColorFracHandle(Color(redByte: 177, greenByte: 199, blueByte: 215), 0.35, 0.50),
        ColorFracHandle(Color(redByte: 203, greenByte: 209, blueByte: 228), 0.67, 0.50),
        ColorFracHandle(Color(redByte: 207, greenByte: 223, blueByte: 223), 0.70, 0.50),
        ColorFracHandle(Color(redByte: 237, greenByte: 217, blueByte: 227), 1.00, 0.50)
        ])

    // Nature
    public static let sky1 = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 108, greenByte: 181, blueByte: 228), 0.00, 0.60),
        ColorFracHandle(Color(redByte: 0, greenByte: 124, blueByte: 194), 0.57, 0.50),
        ColorFracHandle(Color(redByte: 0, greenByte: 89, blueByte: 169), 1.00, 0.50)
        ])
    public static let sky2 = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 204, greenByte: 224, blueByte: 244), 0.00, 0.60),
        ColorFracHandle(Color(redByte: 30, greenByte: 156, blueByte: 215), 0.57, 0.50),
        ColorFracHandle(Color(redByte: 0, greenByte: 117, blueByte: 190), 0.89, 0.50),
        ColorFracHandle(Color(redByte: 0, greenByte: 90, blueByte: 151), 1.00, 0.50)
        ])
    public static let sky3 = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 248, greenByte: 209, blueByte: 117), 0.00, 0.46),
        ColorFracHandle(Color(redByte: 239, greenByte: 145, blueByte: 80), 0.36, 0.52),
        ColorFracHandle(Color(redByte: 203, greenByte: 114, blueByte: 50), 0.55, 0.50),
        ColorFracHandle(Color(redByte: 141, greenByte: 74, blueByte: 36), 1.00, 0.50)
        ])
    public static let sky4 = blend(colorFracHandles: [
        ColorFracHandle(Color(redByte: 203, greenByte: 114, blueByte: 50), 0.00, 0.46),
        ColorFracHandle(Color(redByte: 239, greenByte: 145, blueByte: 80), 0.13, 0.52),
        ColorFracHandle(Color(redByte: 247, greenByte: 210, blueByte: 145), 0.39, 0.48),
        ColorFracHandle(Color(redByte: 221, greenByte: 188, blueByte: 166), 0.55, 0.50),
        ColorFracHandle(Color(redByte: 198, greenByte: 169, blueByte: 181), 0.71, 0.50),
        ColorFracHandle(Color(redByte: 142, greenByte: 98, blueByte: 133), 1.00, 0.38)
        ])
    public static let water1 = blend(colorFracs: [
        ColorFrac(Color(redByte: 33, greenByte: 44, blueByte: 41), 0.00),
        ColorFrac(Color(redByte: 124, greenByte: 170, blueByte: 179), 0.45),
        ColorFrac(Color(redByte: 141, greenByte: 185, blueByte: 207), 0.60),
        ColorFrac(Color(redByte: 154, greenByte: 172, blueByte: 203), 0.80),
        ColorFrac(Color(redByte: 122, greenByte: 127, blueByte: 159), 1.00)
        ])
    public static let water2 = blend(colors: [
        Color(redByte: 45, greenByte: 20, blueByte: 79),
        Color(redByte: 81, greenByte: 46, blueByte: 145),
        Color(redByte: 74, greenByte: 86, blueByte: 166),
        Color(redByte: 82, greenByte: 125, blueByte: 191),
        Color(redByte: 124, greenByte: 187, blueByte: 230),
        Color(redByte: 199, greenByte: 234, blueByte: 251)
        ])

    // Spectra
    //public static let hues = { (#frac: Double) -> Color in return Color(hue: frac, saturation: 1, brightness: 1) }
    public static let redYellowBlue = makeThreeColor(.red, .yellow, .blue)
    public static let spectrum = blend(colors: [
        Color(redByte: 0, greenByte: 168, blueByte: 222),
        Color(redByte: 51, greenByte: 51, blueByte: 145),
        Color(redByte: 233, greenByte: 19, blueByte: 136),
        Color(redByte: 235, greenByte: 45, blueByte: 46),
        Color(redByte: 253, greenByte: 233, blueByte: 43),
        Color(redByte: 0, greenByte: 158, blueByte: 84)
        ])


    public static func hues(frac: Double) -> Color {
        return Color(hue: frac, saturation: 1, brightness: 1)
    }

    public static let gradients: [ColorFunc] = [
        Gradient.grayscale,

        Gradient.goldRedOrange,
        Gradient.bluegreenBlueGreen,
        Gradient.blueMagentaRed,
        Gradient.yellowGoldGreen,
        Gradient.chartreuseYellowGreen,

        Gradient.orangeMediumblue,
        Gradient.purpleGold,
        Gradient.redGreen,

        Gradient.chartreusePurple,
        Gradient.greenOrange,
        Gradient.deepblueOrange,

        Gradient.bluePurpleOrange,
        Gradient.yellowBluePurple,
        Gradient.chartreuseBlueRed,
        Gradient.greenMagentaOrange,
        Gradient.bluegreenRedOrange,
        Gradient.orangeBlueOrange,
        Gradient.goldPurpleOrange,
        Gradient.chartreuseBlueOrange,

        Gradient.coffee,
        Gradient.valentine,
        Gradient.strata1,
        Gradient.strata2,
        Gradient.strata3,

        Gradient.spring,
        Gradient.summer,
        Gradient.autumn,
        Gradient.winter,

        Gradient.sky1,
        Gradient.sky2,
        Gradient.sky3,
        Gradient.sky4,
        Gradient.water1,
        Gradient.water2,

        Gradient.hues,
        Gradient.redYellowBlue,
        Gradient.spectrum
        ]
}
