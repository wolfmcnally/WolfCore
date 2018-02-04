//
//  PipeOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/14/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

///
/// Pipe-Operator
///
infix operator |> : PipeLeftPrecedence
infix operator <| : PipeRightPrecedence

precedencegroup PipeLeftPrecedence {
    associativity: left
    higherThan: ComparisonPrecedence
    lowerThan: NilCoalescingPrecedence
}

precedencegroup PipeRightPrecedence {
    associativity: right
    higherThan: ComparisonPrecedence
    lowerThan: NilCoalescingPrecedence
}

// precedence is above comparative operators (130) and below additive operators (140)
//{ associativity left precedence 138 }


/// An operator to transform a monad.
///
/// - parameters:
///     - lhs: The monad to be transformed.
///     - rhs: The function to be called to perform the transformation.
public func |> <A, B>(lhs: A, rhs: (A) -> B) -> B {
    return rhs(lhs)
}

public func |> <A, B>(lhs: A, rhs: (A) -> () -> B) -> B {
    return rhs(lhs)()
}

/// An operator to transform a monad. The transformation function may throw.
///
/// - parameters:
///     - lhs: The monad to be transformed.
///     - rhs: The function to be called to perform the transformation.
public func |> <A, B>(lhs: A, rhs: (A) throws -> B) throws -> B {
    return try rhs(lhs)
}

public func |> <A, B>(lhs: A, rhs: (A) -> () throws -> B) throws -> B {
    return try rhs(lhs)()
}

/// An operator used to transform a monad in place or where a side effect
/// of the transformation function is all that matters.
///
/// - parameters:
///     - lhs: The monad to be transformed.
///     - rhs: The function to be called to perform the transformation or
///             generate a side-effect.
@discardableResult public func |> <A>(lhs: A, rhs: (A) -> Void) -> A {
    rhs(lhs)
    return lhs
}

//public func |> <A>(lhs: A, rhs: (A) -> (Void) -> Void) -> A {
//    rhs(lhs)()
//    return lhs
//}
