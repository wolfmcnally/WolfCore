//
//  MatchRegularExpressionOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

///
/// Match-Regular-Expression-Operator
///
infix operator ~?
infix operator ~??

public func ~?? (regex: NSRegularExpression, str: String) -> [TextCheckingResult] {
  return regex.matches(in: str, options: [], range: str.nsRange)
}

public func ~? (regex: NSRegularExpression, str: String) -> Bool {
  return (regex ~?? str).count > 0
}
