//
//  CreateRegularExpressionOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

///
/// Create-Regular-Expression-Operator
///
prefix operator ~/

public prefix func ~/ (pattern: String) throws -> NSRegularExpression {
  return try NSRegularExpression(pattern: pattern, options: [])
}

//public func testRegex() -> Bool {
//  let regex = try! ~/"\\wpple"
//  let str = "Foo"
//
//  return regex ~? str
//}
