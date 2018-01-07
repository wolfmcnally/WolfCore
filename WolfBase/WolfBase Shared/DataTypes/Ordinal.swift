//
//  Ordinal.swift
//  WolfBase
//
//  Created by Wolf McNally on 10/31/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public struct Ordinal {
    public let a: [Int]

    private init(_ a: [Int]) {
        self.a = a
    }

    public init() {
        self.init([0])
    }

    public init(before o: Ordinal) {
        a = [o.a[0] - 1]
    }

    public init(after o: Ordinal) {
        a = [o.a[0] + 1]
    }

    public init(after ord1: Ordinal, before ord2: Ordinal) {
        let len1 = ord1.a.count
        let len2 = ord2.a.count
        if len1 > len2 {
            a = Array(ord1.a.dropLast()) + [ord1.a.last! + 1]
        } else if len1 < len2 {
            a = Array(ord2.a.dropLast()) + [ord2.a.last! - 1]
        } else {
            a = ord1.a + [1]
        }
    }
}

extension Ordinal: Comparable {
    public static func == (lhs: Ordinal, rhs: Ordinal) -> Bool {
        return lhs.a == rhs.a
    }

    public static func < (lhs: Ordinal, rhs: Ordinal) -> Bool {
        return lhs.a.lexicographicallyPrecedes(rhs.a)
    }
}

extension Ordinal: CustomStringConvertible {
    public var description: String {
        return "(" + (a.map { String(describing: $0) }).joined(separator: ", ") + ")"
    }
}
