//
//  SortWeight.swift
//  WolfCore
//
//  Created by Wolf McNally on 10/27/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public enum SortWeight: Comparable, CustomStringConvertible {
    case int(Int)
    case double(Double)
    case string(String)
    case ordinal(Ordinal)
    indirect case list([SortWeight])

    public var description: String {
        switch self {
        case .int(let i):
            return String(describing: i)
        case .double(let d):
            return String(describing: d)
        case .string(let s):
            return "\"\(String(describing: s))\""
        case .ordinal(let o):
            return String(describing: o)
        case .list(let o):
            return String(describing: o)
        }
    }

    private static func comparisonError(lhs: SortWeight, rhs: SortWeight) -> Never {
        print("Cannot compare mismatched elements: \(lhs) and \(rhs).")
        preconditionFailure()
    }

    public static func == (lhs: SortWeight, rhs: SortWeight) -> Bool {
        switch lhs {
        case .int(let i1):
            switch rhs {
            case .int(let i2):
                return i1 == i2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .double(let d1):
            switch rhs {
            case .double(let d2):
                return d1 == d2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .string(let s1):
            switch rhs {
            case .string(let s2):
                return s1 == s2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .ordinal(let o1):
            switch rhs {
            case .ordinal(let o2):
                return o1 == o2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .list(let o1):
            switch rhs {
            case .list(let o2):
                return o1 == o2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        }
    }

    public static func < (lhs: SortWeight, rhs: SortWeight) -> Bool {
        switch lhs {
        case .int(let i1):
            switch rhs {
            case .int(let i2):
                return i1 < i2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .double(let d1):
            switch rhs {
            case .double(let d2):
                return d1 < d2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .string(let s1):
            switch rhs {
            case .string(let s2):
                return s1 < s2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .ordinal(let o1):
            switch rhs {
            case .ordinal(let o2):
                return o1 < o2
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        case .list(let o1):
            switch rhs {
            case .list(let o2):
                return o1.lexicographicallyPrecedes(o2)
            default:
                comparisonError(lhs: lhs, rhs: rhs)
            }
        }
    }
}
