//
//  Frac.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/19/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

/// `Frac` represents a `Double` value that should always be constrained to the closed interval `0.0 .. 1.0`. Although it is a simple typealias and therefore cannot do bounds checking, it is quite useful as a way to document a value as being fractional in nature. Within WolfCore it is often used for values like color components or interpolation amounts.
public typealias Frac = Double

/// Asserts that the value is in the closed interval `0.0 .. 1.0`. As this function is generic, it can be used with the `Frac` typealias or any other floating-point type.
public func assertFrac<T: BinaryFloatingPoint>(_ n: T) {
    assert(0.0 <= n && n <= 1.0)
}
