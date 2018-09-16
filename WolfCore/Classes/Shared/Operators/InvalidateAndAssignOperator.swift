//
//  InvalidateAndAssignOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com.
//

///
/// Invalidate-and-Assign-Operator
///
/// The special character here ("◊") is called the "lozenge" and is typed by pressing Shift-Option-V.
///
infix operator ◊= : AssignmentPrecedence

public func ◊= <T: Invalidatable>(lhs: inout T, rhs: @autoclosure () -> T) {
    lhs.invalidate()
    lhs = rhs()
}

public func ◊= <T: Invalidatable>(lhs: inout T!, rhs: @autoclosure () -> T) {
    lhs?.invalidate()
    lhs = rhs()
}
