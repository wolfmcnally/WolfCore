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
            interval = current .. interval.b
            current = T(0.5).lerpedFromFrac(to: interval)
        case .orderedDescending:
            interval = interval.a .. current
            current = T(0.5).lerpedFromFrac(to: interval)
        }
    }
}

public func binarySearch<T: BinaryFloatingPoint, S>(interval: Interval<T>, start: T, state: S, compare: (T, S) -> (ComparisonResult, S)) -> S {
    var current = start
    var interval = interval
    var state = state
    while true {
        let result: ComparisonResult
        (result, state) = compare(current, state)
        switch result {
        case .orderedSame:
            return state
        case .orderedAscending:
            interval = current .. interval.b
            current = T(0.5).lerpedFromFrac(to: interval)
        case .orderedDescending:
            interval = interval.a .. current
            current = T(0.5).lerpedFromFrac(to: interval)
        }
    }
}

public func compareNeverGreater<T: BinaryFloatingPoint>(_ value1: T, _ value2: T, tolerance: T) -> ComparisonResult {
    guard value1 <= value2 else { return .orderedDescending }
    guard abs(value2 - value1) > tolerance else { return .orderedSame }
    return .orderedAscending
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


