//
//  DegressToRadiansOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 11/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// Degrees-To-Radians-Operator
///
/// The special character here ("°") is called the "degree symbol" and is typed by pressing Option-Shift-8.
///
/// This allows radian angles to be easily expressed in degrees:
///
///   let a = 90°
///   let b = .pi / 2
///
/// `a` and `b` are equal.
///
postfix operator °

public postfix func °<T: BinaryFloatingPoint>(rhs: T) -> T {
    return radians(for: rhs)
}
