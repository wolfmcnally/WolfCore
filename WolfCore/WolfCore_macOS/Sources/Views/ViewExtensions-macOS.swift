//
//  ViewExtensions-macOS.swift
//  WolfCore_macOS
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Cocoa

extension NSView {
  public var alpha: CGFloat {
    get {
      return alphaValue
    }

    set {
      alphaValue = newValue
    }
  }

  public func setNeedsLayout() {
    needsLayout = true
  }

  public func layoutIfNeeded() {
    layoutSubtreeIfNeeded()
  }
}
