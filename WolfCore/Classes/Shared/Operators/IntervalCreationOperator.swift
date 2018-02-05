//
//  IntervalCreationOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/16/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

infix operator .. : RangeFormationPrecedence

/// Operator to create a closed floating-point interval. The first number may
/// be greater than the second. Examples:
///
///     let i = 0..100
///     let j = 100..3.14
///
/// - Parameter left: The first bound. May be greater than the second bound
/// - Parameter right: The second bound.
public func .. <T>(left: T, right: T) -> Interval<T> {
    return Interval(left, right)
}
