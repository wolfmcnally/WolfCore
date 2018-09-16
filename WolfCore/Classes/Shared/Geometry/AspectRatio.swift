//
//  AspectRatio.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/12/17.
//  Copyright © 2017 WolfMcNally.com.
//

import ExtensibleEnumeratedName

public struct AspectRatio: ExtensibleEnumeratedName, Reference {
    private typealias `Self` = AspectRatio

    public let rawValue: String
    public var aspectSize: Size {
        return Self.associatedAspects[self]!
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // Reference
    public var referent: Size {
        return aspectSize
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension AspectRatio {
    public static let square = AspectRatio("square")
    public static let ratio3to2 = AspectRatio("ratio3to2")
    public static let ratio5to3 = AspectRatio("ratio5to3")
    public static let ratio4to3 = AspectRatio("ratio4to3")
    public static let ratio5to4 = AspectRatio("ratio5to4")
    public static let ratio7to5 = AspectRatio("ratio7to5")
    public static let ratio16to9 = AspectRatio("ratio16to9")

    public static var associatedAspects: [AspectRatio: Size] = [
        .square: Size(width: 1, height: 1),
        .ratio3to2: Size(width: 3, height: 2),
        .ratio5to3: Size(width: 5, height: 3),
        .ratio4to3: Size(width: 4, height: 3),
        .ratio5to4: Size(width: 5, height: 4),
        .ratio7to5: Size(width: 7, height: 5),
        .ratio16to9: Size(width: 16, height: 9)
        ]
}
