//
//  LayoutRelation.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
  public typealias LayoutRelation = NSLayoutConstraint.Relation
#else
  import UIKit
  public typealias LayoutRelation = NSLayoutRelation
#endif

public func string(forRelation relation: LayoutRelation) -> String {
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
