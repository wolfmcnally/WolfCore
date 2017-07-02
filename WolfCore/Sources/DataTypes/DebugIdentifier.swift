//
//  DebugIdentifier.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

private var debugIdentifierKey = "debugIdentifier"

extension NSObject {
  /// A string used for debugging purposes that can be set on any NSObject.
  public var debugIdentifier: String? {
    get {
      return getAssociatedValue(for: &debugIdentifierKey)
    }

    set {
      setAssociatedValue(newValue, for: &debugIdentifierKey)
    }
  }
}
