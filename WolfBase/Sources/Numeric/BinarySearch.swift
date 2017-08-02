//
//  BinarySearch.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

@discardableResult public func binarySearch<T: BinaryFloatingPoint>(interval: Interval<T>, start: T, compare: (T) -> ComparisonResult) -> T {
  var current = start
  var interval = interval
  while true {
    switch compare(current) {
    case .orderedSame:
      return current
    case .orderedAscending:
      interval = current..interval.b
      current = T(0.5).lerpedFromFrac(to: interval)
    case .orderedDescending:
      interval = interval.a..current
      current = T(0.5).lerpedFromFrac(to: interval)
    }
  }
}

public func compareNeverGreater<T: BinaryFloatingPoint>(_ value1: T, _ value2: T, tolerance: T) -> ComparisonResult {
  guard value1 <= value2 else { return .orderedDescending }
  guard abs(value2 - value1) > tolerance else { return .orderedSame }
  return .orderedAscending
}

public func isNearLimits<T: BinaryFloatingPoint>(_ value: T, limits: Interval<T>, tolerance: T) -> Bool {
  guard abs(value - limits.a) > tolerance else { return true }
  guard abs(value - limits.b) > tolerance else { return true }
  return false
}

extension ComparisonResult {
  public var operatorString: String {
    switch self {
    case .orderedSame:
      return "=="
    case .orderedAscending:
      return "<"
    case .orderedDescending:
      return ">"
    }
  }
}


