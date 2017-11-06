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
    ///     5.lerped(from: 0..<10, to: 0..90) == 50.0
    public func lerpedFromRange<T: BinaryFloatingPoint>(_ range: CountableRange<Int>, to interval: Interval<T>) -> T {
        return T(self).lerped(from: T(range.lowerBound)..T(range.upperBound - 1), to: interval)
    }
    
    /// Interpolates from a integer `CountableClosedRange` to a floating-point `Interval`.
    ///
    ///     5.lerped(from: 0..<10, to: 0..100) == 50.0
    public func lerpedFromRange<T: BinaryFloatingPoint>(_ range: CountableClosedRange<Int>, to interval: Interval<T>) -> T {
        return T(self).lerped(from: T(range.lowerBound)..T(range.upperBound), to: interval)
    }
}

extension BinaryFloatingPoint {
    /// The value lerped from the interval `a..b` into the interval `0..1`. (`a` may be greater than `b`).
    public func lerpedToFrac(from interval: Interval<Self>) -> Self {
        let from = interval.a - interval.b
        assert(from != 0.0)
        return (interval.a - self) / from
    }
    
    /// The value lerped from the interval `0..1` to the interval `a..b`. (`a` may be greater than `b`).
    public func lerpedFromFrac(to interval: Interval<Self>) -> Self {
        return self * (interval.b - interval.a) + interval.a
    }
    
    /// The value lerped from the interval `a1..b1` to the interval `a2..b2`. (the `a`'s may be greater than the `b`'s).
    public func lerped(from interval1: Interval<Self>, to interval2: Interval<Self>) -> Self {
        return interval2.a + ((interval2.b - interval2.a) * (self - interval1.a)) / (interval1.b - interval1.a)
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
