//
//  Lerp.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

/// "Lerp" is an abbreviation for "linear interpolation."

/// These functions map a value from one linear space to another.

extension Int {
    /// Interpolates from a integer `CountableRange` to a floating-point `Interval`.
    ///
    ///     5.lerped(from: 0 ..< 10, to: 0 .. 90) == 50.0
    public func lerpedFromRange<T: BinaryFloatingPoint>(_ range: CountableRange<Int>, to interval: Interval<T>) -> T {
        return T(self).lerped(from: T(range.lowerBound)..T(range.upperBound - 1), to: interval)
    }
    
    /// Interpolates from a integer `CountableClosedRange` to a floating-point `Interval`.
    ///
    ///     5.lerped(from: 0 ..< 10, to: 0 .. 100) == 50.0
    public func lerpedFromRange<T: BinaryFloatingPoint>(_ range: CountableClosedRange<Int>, to interval: Interval<T>) -> T {
        return T(self).lerped(from: T(range.lowerBound)..T(range.upperBound), to: interval)
    }
}

extension BinaryFloatingPoint {
    /// The value lerped from the interval `a .. b` into the interval `0 .. 1`. (`a` may be greater than `b`).
    public func lerpedToFrac(from interval: Interval<Self>) -> Self {
        let a = interval.a
        let b = interval.b
        let from = a - b

        assert(self.isFinite)
        assert(a.isFinite)
        assert(b.isFinite)
        assert(from != 0.0)

        return (a - self) / from
    }
    
    /// The value lerped from the interval `0 .. 1` to the interval `a .. b`. (`a` may be greater than `b`).
    public func lerpedFromFrac(to interval: Interval<Self>) -> Self {
        let a = interval.a
        let b = interval.b

        assert(self.isFinite)
        assert(a.isFinite)
        assert(b.isFinite)

        return self * (b - a) + a
    }
    
    /// The value lerped from the interval `a1 .. b1` to the interval `a2 .. b2`. (the `a`'s may be greater than the `b`'s).
    public func lerped(from interval1: Interval<Self>, to interval2: Interval<Self>) -> Self {
        let a1 = interval1.a
        let b1 = interval1.b
        let a2 = interval2.a
        let b2 = interval2.b

        assert(self.isFinite)
        assert(a1.isFinite)
        assert(b1.isFinite)
        assert(a2.isFinite)
        assert(b2.isFinite)

        return a2 + ((b2 - a2) * (self - a1)) / (b1 - a1)
    }
}

extension BinaryFloatingPoint {
    public func circularInterpolate(to i: Interval<Self>) -> Self {
        let c = abs(i.a - i.b)
        if c <= 0.5 {
            return self.lerpedFromFrac(to: i)
        } else {
            var s: Self
            if i.a <= i.b {
                s = self.lerpedFromFrac(to: i.a .. i.b - 1.0)
                if s < 0.0 { s += 1.0 }
            } else {
                s = self.lerpedFromFrac(to: i.a .. i.b + 1.0)
                if s >= 1.0 { s -= 1.0 }
            }
            return s
        }
    }
}
