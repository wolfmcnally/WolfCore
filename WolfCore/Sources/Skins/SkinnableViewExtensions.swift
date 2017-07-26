//
//  SkinnableUIViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

import WolfBase

extension LogGroup {
  public static let skinV = LogGroup("skinV")
}

struct SkinnableAssociatedKeys {
  static var privateSkin = "WolfCore_privateSkin"
}

var skinIndentLevel = 0

extension OSView {
  fileprivate var privateSkin: Skin? {
    get {
      return getAssociatedValue(for: &SkinnableAssociatedKeys.privateSkin)
    }
    
    set {
      setAssociatedValue(newValue, for: &SkinnableAssociatedKeys.privateSkin)
    }
  }
}

extension OSView {
  public var skin: Skin! {
    get {
      guard skinsEnabled else { return nil }
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

extension OSView {
  public func _reviseSkin(_ skin: Skin) -> Skin? {
    return nil
  }
  
  public func _applySkin(_ skin: Skin) {
    #if !os(macOS)
      normalBackgroundColor ©= skin.viewBackgroundColor
      tintColor ©= skin.tintColor
    #endif
  }
}

extension OSView {
  func set(skin: Skin!) {
    skinIndentLevel += 1
    defer { skinIndentLevel -= 1 }
    
    logTrace("💟 💖 set \(self††)) to \((skin?.identifierPath)†)".indented(skinIndentLevel), group: .skinV)
    
    privateSkin = skin
    let s = (skin ?? self.skin)!
    OSView.propagate(skin: s, to: self)
  }
  
  fileprivate static func propagate(skin: Skin, to view: OSView) {
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
    guard skinsEnabled else { return }
    let skin = self.skin!
    logTrace("💟 [\(why)] \(skin.identifierPath) ⏩ \(self††)", group: .skinV)
    OSView.propagate(skin: skin, to: self)
  }
}
