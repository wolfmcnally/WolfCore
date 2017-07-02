//
//  LayoutAttribute.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
  public typealias LayoutAttribute = NSLayoutConstraint.Attribute
#else
  import UIKit
  public typealias LayoutAttribute = NSLayoutAttribute
#endif

#if os(macOS)
public func string(forAttribute attribute: LayoutAttribute) -> String {
  let result: String
  switch attribute {
  case .left:
    result = "left"
  case .right:
    result = "right"
  case .top:
    result = "top"
  case .bottom:
    result = "bottom"
  case .leading:
    result = "leading"
  case .trailing:
    result = "trailing"
  case .width:
    result = "width"
  case .height:
    result = "height"
  case .centerX:
    result = "centerX"
  case .centerY:
    result = "centerY"
  case .lastBaseline:
    result = "lastBaseline"
  case .firstBaseline:
    result = "firstBaseline"
  case .notAnAttribute:
    result = "notAnAttribute"
  }
  return result
}
#else
  public func string(forAttribute attribute: LayoutAttribute) -> String {
    let result: String
    switch attribute {
    case .left:
      result = "left"
    case .right:
      result = "right"
    case .top:
      result = "top"
    case .bottom:
      result = "bottom"
    case .leading:
      result = "leading"
    case .trailing:
      result = "trailing"
    case .width:
      result = "width"
    case .height:
      result = "height"
    case .centerX:
      result = "centerX"
    case .centerY:
      result = "centerY"
    case .firstBaseline:
      result = "firstBaseline"
    case .lastBaseline:
      result = "lastBaseline"
    case .notAnAttribute:
      result = "notAnAttribute"
    case .leftMargin:
      result = "leftMargin"
    case .rightMargin:
      result = "rightMargin"
    case .topMargin:
      result = "topMargin"
    case .bottomMargin:
      result = "bottomMargin"
    case .leadingMargin:
      result = "leadingMargin"
    case .trailingMargin:
      result = "trailingMargin"
    case .centerXWithinMargins:
      result = "centerXWithinMargins"
    case .centerYWithinMargins:
      result = "centerYWithinMargins"
    }
    return result
  }
#endif
