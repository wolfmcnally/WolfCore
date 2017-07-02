//
//  WithOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// With-Operator
///
infix operator • : CastingPrecedence

@discardableResult public func • <T: Any>(lhs: T, rhs: (inout T) -> Void) -> T {
  var lhs = lhs
  rhs(&lhs)
  return lhs
}

@discardableResult public func • <T: AnyObject>(lhs: T, rhs: (T) -> Void) -> T {
  rhs(lhs)
  return lhs
}
