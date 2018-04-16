//
//  StringExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/13/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

#if canImport(CoreGraphics)
    import CoreGraphics
#endif

extension String {
    public var debugSummary: String {
        return escapingNewlines().truncated(afterCount: 20)
    }
}

// Support the Serializable protocol used for caching
extension String: Serializable {
    public typealias ValueType = String

    public func serialize() -> Data {
        return self |> Data.init
    }

    public static func deserialize(from data: Data) throws -> String {
        return try data |> UTF8.init |> String.init
    }
}

extension String {
    public static let empty = ""
    public static let space = " "
    public static let comma = ","
    public static let tab = "\t"
    public static let newline = "\n"
    public static let cr = "\r"
    public static let crlf = "\r\n"
}

#if !os(Linux)
public extension NSString {
    var cgFloatValue: CGFloat {
        return CGFloat(self.doubleValue)
    }
}
#endif
