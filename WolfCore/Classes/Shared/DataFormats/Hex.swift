//
//  Hex.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding hexadecimal encoded strings.
public struct Hex {
    private typealias `Self` = Hex
    private static let hexDigits = Array("0123456789abcdef".utf16)

    public enum Error: Swift.Error {
        /// Thrown if the String cannot be decoded to Data.
        case invalid
    }

    /// The hexadecimal encoded representation.
    public let string: String
    /// The raw data.
    public let data: Data

    /// Create a Hex from a hexadecimal encoded String. Throws if the String cannot be decoded to Data.
    ///
    /// May be used as a monad transformer.
    public init(string: String) throws {
        let charactersCount = string.count

        var data: Data

        if charactersCount == 1 {
            guard let b = UInt8(string, radix: 16) else {
                throw Error.invalid
            }
            data = Data(count: 1)
            data[0] = b
        } else {
            guard charactersCount % 2 == 0 else {
                throw Error.invalid
            }

            let bytesCount = charactersCount / 2

            data = Data(count: bytesCount)
            for (index, s) in string.split(by: 2).enumerated() {
                guard let b = UInt8(s, radix: 16) else {
                    throw Error.invalid
                }
                data[index] = b
            }
        }

        self.data = data
        self.string = string
    }

    /// Create a Hex from a Data.
    ///
    /// May be used as a monad transformer.
    public init(data: Data) {
        var chars: [unichar] = []
        chars.reserveCapacity(2 * data.count)
        for byte in data {
            chars.append(Self.hexDigits[Int(byte / 16)])
            chars.append(Self.hexDigits[Int(byte % 16)])
        }
        self.data = data
        self.string = String(utf16CodeUnits: chars, count: chars.count)
    }

    /// Create a Hex from a single byte.
    ///
    /// May be used as a monad transformer.
    public init(byte: UInt8) {
        self.init(data: Data(bytes: [byte]))
    }
}

extension Hex: CustomStringConvertible {
    public var description: String {
        return "\"\(string)\""
    }
}

extension String {
    /// Extract a hexadecimal encoded String from a Hex.
    ///
    /// May be used as a monad transformer.
    public init(hex: Hex) {
        self.init(hex.string)
    }
}

extension Data {
    /// Extract a Data from a Hex.
    ///
    /// May be used as a monad transformer.
    public init(hex: Hex) {
        self.init(hex.data)
    }
}

extension UInt8 {
    /// Extract the first byte from a Hex.
    ///
    /// May be used as a monad transformer.
    public init(hex: Hex) {
        self.init(hex.data[0])
    }
}
