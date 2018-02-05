//
//  Interval.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/19/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

/// Represents a closed floating-point interval from `a`..`b`. Unlike ClosedRange,
/// `a` may be greater than `b`.
public struct Interval<T: FloatingPoint> {
    public typealias Bound = T
    
    public let a: Bound
    public let b: Bound

    /// Creates a closed interval from `a`..`b`. `a` may be greater than `b`.
    public init(_ a: Bound, _ b: Bound) {
        self.a = a
        self.b = b
    }
}

extension Interval {
    /// Returns `true` if `a` is less than `b`, and `false` otherwise.
    public var isAscending: Bool {
        return a < b
    }
    
    /// Returns `true` if `a` is greater than `b`, and `false` otherwise.
    public var isDescending: Bool {
        return a > b
    }
    
    /// Returns `true` if `a` is equal to `b`, and `false` otherwise.
    public var isFlat: Bool {
        return a == b
    }
}

extension Interval {
    /// Returns an interval with the same bounds as this interval, but swapped
    public func swapped() -> Interval {
        return Interval(b, a)
    }
    
    /// Returns an interval with the same bounds as this interval, but where `a` is the minimum bound and `b` is the maximum bound.
    public func normalized() -> Interval {
        return isAscending ? self : swapped()
    }
}

extension Interval {
    /// Returns the lesser of the two bounds
    public var min: Bound {
        return Swift.min(a, b)
    }
    
    /// Returns the greater of the two bounds
    public var max: Bound {
        return Swift.max(a, b)
    }

    /// Returns `true` if the interval contains the value `n`, otherwise returns `false`.
    public func contains(_ n: Bound) -> Bool {
        return min <= n && n <= max
    }
    
    /// Returns `true` if the interval fully contains the `other` interval.
    public func contains(_ other: Interval) -> Bool {
        return min <= other.min && other.max <= max
    }
    
    /// Returns `true` if the interval intersects with the `other` interval.
    public func intersects(with other: Interval) -> Bool {
        return contains(other.a) || contains(other.b)
    }
    
    /// Returns the interval that is the intersection of this interval with the `other` interval.
    /// If the intervals do not intersect, return `nil`.
    public func intersection(with other: Interval) -> Interval? {
        guard intersects(with: other) else { return nil }
        return Interval(Swift.max(min, other.min), Swift.min(max, other.max))
    }
    
    /// Returns an interval with `a` being the least bound of the two intervals,
    /// and `b` being the greatest bound of the two intervals.
    public func extent(with other: Interval) -> Interval {
        return Interval(Swift.min(min, other.min), Swift.max(max, other.max))
    }
}

extension Interval: CustomStringConvertible {
    public var description: String {
        return "Interval(\(a) .. \(b))"
    }
}

extension Interval {
    /// Converts a `ClosedRange` to an Interval.
    public init(_ i: ClosedRange<Bound>) {
        self.a = i.lowerBound
        self.b = i.upperBound
    }
    
    /// Converts this `Interval` to a `ClosedRange`. If `a` > `b` then `b`
    /// will be the range's `lowerBound`.
    public var closedRange: ClosedRange<Bound> {
        let i = normalized()
        return i.a ... i.b
    }
}

extension Double {
    public static let unit = Interval<Double>(0, 1)
}

extension Float {
    public static let unit = Interval<Float>(0, 1)
}

#if !os(Linux)
    import CoreGraphics

    extension CGFloat {
        public static let unit = Interval<CGFloat>(0, 1)
    }
#endif
