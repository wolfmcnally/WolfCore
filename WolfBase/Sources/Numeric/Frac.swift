//
//  Frac.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/19/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

/// `Frac` represents a `Double` value that should always be constrained to the interval `0.0...1.0`. Although it is a simple typealias and therefore cannot do bounds checking, it is quite useful as a way to document a value as being fractional in nature. Within WolfBase it is often used for values like color components or interpolation amounts.
public typealias Frac = Double
