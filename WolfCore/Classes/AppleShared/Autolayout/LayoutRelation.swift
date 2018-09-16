//
//  NSLayoutConstraint.Relation.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public func string(forRelation relation: NSLayoutConstraint.Relation) -> String {
    let result: String
    switch relation {
    case .equal:
        result = "=="
    case .lessThanOrEqual:
        result = "<="
    case .greaterThanOrEqual:
        result = ">="
    }
    return result
}
