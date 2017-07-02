//
//  BinarySearch.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public func binarySearch<T: BinaryFloatingPoint>(interval: Interval<T>, start: T, compare: (T) -> ComparisonResult) -> T {
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

