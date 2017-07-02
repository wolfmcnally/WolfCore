//
//  InvalidateAndAssignOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// Invalidate-and-Assign-Operator
///
infix operator ◊= : AssignmentPrecedence

public func ◊= <T: Invalidatable>(lhs: inout T, rhs: @autoclosure () -> T) {
  lhs.invalidate()
  lhs = rhs()
}
