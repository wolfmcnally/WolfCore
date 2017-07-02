//
//  Interval.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/19/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

infix operator .. : RangeFormationPrecedence

/// Operator to create a closed floating-point literal. The first number may
/// be greater than the second. Examples:
///
///     let i = 0..100
///     let j = 100..3.14
///
/// - Parameter left: The first bound. May be greater than the second bound
/// - Parameter right: The second bound.
public func .. <T>(left: T, right: T) -> Interval<T> {
  return Interval(a: left, b: right)
}

/// Represents a closed floating-point interval from `a`..`b`. Unlike ClosedRange,
/// `a` may be greater than `b`.
public struct Interval<T: FloatingPoint> {
  public let a: T
  public let b: T

  /// Creates an closed interval from `a`..`b`. `a` may be greater than `b`.
  public init(a: T, b: T) {
    self.a = a
    self.b = b
  }

  /// Converts a `ClosedRange` to an Interval.
  public init(_ i: ClosedRange<T>) {
    self.a = i.lowerBound
    self.b = i.upperBound
  }

  /// Converts this `Interval` to a `ClosedRange`. If `a` > `b` then `b`
  /// will be the range's `lowerBound`.
  public var closedRange: ClosedRange<T> {
    return a <= b ? a...b : b...a
  }

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

extension Double {
  public static let unit = Interval<Double>(a: 0, b: 1)
}

extension Float {
  public static let unit = Interval<Float>(a: 0, b: 1)
}

#if !os(Linux)
  import CoreGraphics

  extension CGFloat {
    public static let unit = Interval<CGFloat>(a: 0, b: 1)
  }
#endif
