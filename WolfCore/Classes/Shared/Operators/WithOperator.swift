//
//  WithOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com.
//

///
/// With-Operator
///
/// The special character here ("•") is called the "bullet" and is typed by pressing Option-8.
///
infix operator • : CastingPrecedence
infix operator •• : CastingPrecedence
infix operator ••• : CastingPrecedence

/// This version of the with-operator is used to configure reference type (class) instances
/// and also returns the reference for assignment:
///
///   let view = View() • {
///       $0.backgroundColor = .red
///   }
///
/// Because the right-hand side of the with-operator is a class instance, you can operate on a
/// pre-existing instance:
///
///   view • {
///       $0.alpha = 0.5
///   }
@discardableResult public func • <T: AnyObject>(lhs: T, rhs: (T) throws -> Void) rethrows -> T {
    try rhs(lhs)
    return lhs
}

/// This version of the with-operator is used to configure value type (struct) instances
/// and also returns the modified copy of the instance for assignment.
///
/// Because the right-hand side of the with-operator is a struct instance, you *must*
/// assign the result of this operator. The assignee may be declared as `let`.
///
///   let point = Point.zero •• {
///       $0.x = 10
///   }
///
@discardableResult public func •• <T: Any>(lhs: T, rhs: (inout T) throws -> Void) rethrows -> T {
    var lhs = lhs
    try rhs(&lhs)
    return lhs
}

/// This version of the with-operator is used to configure pre-existing value type
/// (struct) instance.
///
/// Because this modifies the instance in place, it must be delared as `var`.
///
///   var point: Point = .zero
///
///   point ••• {
///       $0.x = 10
///   }
///
public func ••• <T: Any>(lhs: inout T, rhs: (inout T) throws -> Void) rethrows {
    try rhs(&lhs)
}
