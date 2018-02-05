//
//  WithOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// With-Operator
///
/// The special character here ("•") is called the "bullet" and is typed by pressing Option-8.
///
infix operator • : CastingPrecedence
infix operator •• : CastingPrecedence

@discardableResult public func •• <T: Any>(lhs: T, rhs: (inout T) -> Void) -> T {
    var lhs = lhs
    rhs(&lhs)
    return lhs
}

@discardableResult public func • <T: AnyObject>(lhs: T, rhs: (T) -> Void) -> T {
    rhs(lhs)
    return lhs
}
