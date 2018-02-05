//
//  LexNum.swift
//  WolfCore
//
//  Created by Wolf McNally on 10/31/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding integers as strings having the same relative lexicographical order.
///
/// Based on:
/// "Efficient Lexicographic Encoding of Numbers" by Peter Seymour
/// http://www.zanopha.com/docs/elen.pdf

public struct LexNum {
    private typealias `Self` = LexNum

    public enum Error: Swift.Error {
        /// Thrown if the String cannot be decoded to an Int.
        case invalid
    }

    /// The integer representation
    public let int: Int

    /// The String-encoded representation
    public let string: String

    private static let posChar: Character = "="
    private static let negChar: Character = "-"

    public init(_ n: Int) {
        self.int = n
        string = Self.encode(n)
    }

    public init(_ string: String) throws {
        self.string = string
        int = try Self.decode(string)
    }

    private static func encode(_ n: Int) -> String {
        if n == 0 {
            return "0"
        } else if n < 0 {
            let n2 = -n
            return elen(n2, c: negChar) + (_encode(n2) |> invertDigits)
        } else {
            return elen(n, c: posChar) + _encode(n)
        }
    }

    private static func _encode(_ n: Int) -> String {
        return _encode(String(n))
    }

    private static func _encode(_ s: String) -> String {
        let len = s.count
        let r: String
        if len > 9 {
            r = _encode(len)
        } else if len == 1 {
            r = ""
        } else {
            r = String(len)
        }
        return r + s
    }

    private static func elen(_ n: Int, c: Character, acc: String = "") -> String {
        var acc = acc
        if n > 0 {
            acc = acc + String(c)
        }
        let len = Int(ceil(log10(Double(n + 1))))
        if len > 1 {
            return elen(len, c: c, acc: acc)
        } else {
            return acc
        }
    }

    static let invertedDigits: [Character: Character] = [
        "0": "9",
        "1": "8",
        "2": "7",
        "3": "6",
        "4": "5",
        "5": "4",
        "6": "3",
        "7": "2",
        "8": "1",
        "9": "0"
    ]

    private static func invertDigits(_ s: String) -> String {
        return String(s.map { Self.invertedDigits[$0]! })
    }

    private static func decode(_ string: String) throws -> Int {
        guard string != "0" else { return 0 }

        guard string.count > 1 else { throw Error.invalid }

        let firstChar = string.first!
        let neg: Bool
        switch firstChar {
        case posChar:
            neg = false
        case negChar:
            neg = true
        default:
            throw Error.invalid
        }

        var r = Substring(string)
        var count = 0

        repeat {
            count += 1
            r = r.dropFirst()
        } while r.first! == firstChar

        if neg {
            r = Substring(invertDigits(String(r)))
        }

        var r2 = r[ r.index(r.startIndex, offsetBy: count - 1)... ]

        var a: Int = 0
        repeat {
            a *= 10
            guard let v = Int(String(r2.first!)) else { throw Error.invalid }
            a += v
            r2 = r2.dropFirst()
        } while !r2.isEmpty

        return neg ? -a : a
    }
}

extension String {
    /// Extract an encoded String from a LexNum.
    ///
    /// May be used as a monad transformer.
    public init(lexnum: LexNum) {
        self.init(lexnum.string)
    }
}

extension Int {
    /// Extract a decoded Int from a LexNum.
    ///
    /// May be used as a monad transformer.
    public init(lexnum: LexNum) {
        self.init(lexnum.int)
    }
}
