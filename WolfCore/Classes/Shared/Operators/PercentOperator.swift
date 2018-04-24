//
//  PercentOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/24/18.
//

import Foundation

///
/// Percent-Operator
///
postfix operator %

/// Returns the suffixed value / 100. Useful when one naturally expresses literal values as percentages.
public postfix func % <T: BinaryFloatingPoint>(value: T) -> T {
    return value * 0.01
}
