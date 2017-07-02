//
//  InheritsFromOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// Inherits-From Operator
///
///     class A { }
///     class B: A { }
///
///     let b = B()
///
///     b <- UIView.self // prints false
///     b <- A.self      // prints true
///
///     2.0 <- Float.self   // prints false
///     2.0 <- Double.self  // prints true
///
/// - Parameter lhs: The instance to be tested for type.
/// - Parameter rhs: The type to be tested against.
///
infix operator <- : ComparisonPrecedence

public func <- <U, T>(lhs: U?, rhs: T.Type) -> Bool {
  return (lhs as? T) != nil
}
