//
//  UserDefaultsExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 7/13/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

public let userDefaults = UserDefaults.standard

extension LogGroup {
  public static let userDefaults = LogGroup("userDefaults")
}

extension UserDefaults {
  public subscript(key: String) -> Any? {
    get {
      let value = userDefaults.object(forKey: key)
      logTrace("get key: \(key), value: \(value†)", group: .userDefaults)
      return value as AnyObject?
    }
    set {
      logTrace("set key: \(key), newValue: \(newValue†)", group: .userDefaults)
      if let newValue = newValue {
        userDefaults.set(newValue, forKey: key)
      } else {
        userDefaults.removeObject(forKey: key)
      }
      userDefaults.synchronize()
    }
  }
}
