//
//  SkinnableUIViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

extension LogGroup {
  public static let skinV = LogGroup("skinV")
}

extension UIView {
  fileprivate var privateSkin: Skin? {
    get {
      return getAssociatedValue(for: &SkinnableAssociatedKeys.privateSkin)
    }
    
    set {
      setAssociatedValue(newValue, for: &SkinnableAssociatedKeys.privateSkin)
    }
  }
}

extension UIView {
  public var skin: Skin! {
    get {
      if let s = privateSkin {
        return s
      } else if let s = superview?.skin {
        return s
      } else {
        return topSkin
      }
    }
    
    set {
      set(skin: newValue)
    }
  }
}

extension UIView {
  public func _reviseSkin(_ skin: Skin) -> Skin? {
    return nil
  }
  
  public func _applySkin(_ skin: Skin) {
    normalBackgroundColor ©= skin.viewBackgroundColor
    tintColor ©= skin.tintColor
  }
}

extension UIView {
  func set(skin: Skin!) {
    skinIndentLevel += 1
    defer { skinIndentLevel -= 1 }
    
    logTrace("💟 💖 set \(self††)) to \((skin?.identifierPath)†)".indented(skinIndentLevel), group: .skinV)
    
    privateSkin = skin
    let s = (skin ?? self.skin)!
    UIView.propagate(skin: s, to: self)
  }
  
  fileprivate static func propagate(skin: Skin, to view: UIView) {
    skinIndentLevel += 1
    defer { skinIndentLevel -= 1 }
    
    var skin = skin
    
    if let skinnable = view as? Skinnable {
      if let revisedSkin = skinnable.reviseSkin(skin) {
        skin = revisedSkin
        view.privateSkin = skin
        logTrace("💟 💘 \(view††) revised to \(skin.identifierPath)".indented(skinIndentLevel), group: .skinV)
      } else {
        logTrace("💟 💚 \(view††) kept \(skin.identifierPath)".indented(skinIndentLevel), group: .skinV)
      }
      skinnable.applySkin(skin)
    } else {
      logTrace("💟 🖤 \(view††) isn't skinnable".indented(skinIndentLevel), group: .skinV)
    }
    
    for subview in view.subviews {
      guard typeName(of: subview) != "_UILayoutGuide" else { continue }
      
      if let subviewSkin = subview.privateSkin {
        skinIndentLevel += 1
        defer { skinIndentLevel -= 1 }
        
        logTrace("💟 ⛔️ \(subview††) has overriding \(subviewSkin.identifierPath)".indented(skinIndentLevel), group: .skinV)
      } else {
        propagate(skin: skin, to: subview)
      }
    }
  }
  
  public func propagateSkin(why: String) {
    let skin = self.skin!
    logTrace("💟 [\(why)] \(skin.identifierPath) ⏩ \(self††)", group: .skinV)
    UIView.propagate(skin: skin, to: self)
  }
}
