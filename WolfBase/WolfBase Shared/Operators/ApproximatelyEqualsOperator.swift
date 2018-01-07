//
//  ApproximatelyEqualsOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/23/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// Approximately-Equals-Operator
///
infix operator ≈ : ComparisonPrecedence

///
/// Not-Approximately-Equals-Operator
///
infix operator !≈ : ComparisonPrecedence

public func ≈<T: BinaryFloatingPoint>(lhs: T, rhs: (limit: T, tolerance: T)) -> Bool {
    return abs(lhs - rhs.limit) <= rhs.tolerance
}

public func ≈<T: BinaryFloatingPoint>(lhs: T, rhs: (limits: Interval<T>, tolerance: T)) -> Bool {
    return lhs ≈ (rhs.limits.a, rhs.tolerance) || lhs ≈ (rhs.limits.b, rhs.tolerance)
}

public func !≈<T: BinaryFloatingPoint>(lhs: T, rhs: (limits: Interval<T>, tolerance: T)) -> Bool {
    return !(lhs ≈ rhs)
}

public func !≈<T: BinaryFloatingPoint>(lhs: T, rhs: (limit: T, tolerance: T)) -> Bool {
    return !(lhs ≈ rhs)
}
