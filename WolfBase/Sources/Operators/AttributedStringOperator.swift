//
//  AttributedStringOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

///
/// Attributed-String-Operator
///
/// The special character here ("§") is called the "section marker" and is typed by pressing Option-6.
///
postfix operator §

public postfix func § (left: String) -> AttributedString {
    return AttributedString(string: left)
}

public postfix func § (left: AttributedString) -> AttributedString {
    return left.mutableCopy() as! AttributedString
}

public postfix func § (left: String?) -> AttributedString? {
    guard let left = left else { return nil }
    return AttributedString(string: left)
}

public postfix func § (left: AttributedString?) -> AttributedString? {
    guard let left = left else { return nil }
    return left.mutableCopy() as? AttributedString
}

public postfix func § (left: NSAttributedString) -> AttributedString {
    return left.mutableCopy() as! AttributedString
}

public postfix func § (left: NSAttributedString?) -> AttributedString? {
    guard let left = left else { return nil }
    return left.mutableCopy() as? AttributedString
}
