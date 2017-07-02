//
//  SkinKey.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/11/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

public struct SkinKey: ExtensibleEnumeratedName {
  private class DependentKeys {
    var keys = [SkinKey]()
  }
  public let rawValue: String
  private let _dependentKeys = DependentKeys()
  
  public init(_ rawValue: String) {
    self.rawValue = rawValue
  }
  
  public var dependentKeys: [SkinKey] { return _dependentKeys.keys }
  
  public func addDependentKey(_ key: SkinKey) {
    _dependentKeys.keys.append(key)
  }
  
  // RawRepresentable
  public init?(rawValue: String) { self.init(rawValue) }
}

@discardableResult public func => (lhs: SkinKey, rhs: [SkinKey]) -> SkinKey {
  rhs.forEach { lhs.addDependentKey($0) }
  return lhs
}
