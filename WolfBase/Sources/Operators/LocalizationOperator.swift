//
//  LocalizationOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

///
/// Localization-Operator
///
postfix operator ¶
infix operator ¶ : AttributeAssignmentPrecedence

public postfix func ¶ (left: String) -> String {
  return left.localized()
}

public func ¶ (left: String, right: Replacements) -> String {
  return left.localized(replacingPlaceholdersWithReplacements: right)
}
