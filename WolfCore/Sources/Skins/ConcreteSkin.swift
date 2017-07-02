//
//  ConcreteSkin.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/11/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

public struct ConcreteSkin: Skin {
  public var cache = ValueCache()
  
  public init() {
  }
  
  public func get<T: SkinValue>(_ key: SkinKey, _ update: @autoclosure () -> T) -> T {
    return cache.get(key, with: update)
  }
  
  public mutating func set<T: SkinValue>(_ key: SkinKey, to value: T) {
    guard value != cache.get(key) else { return }
    if !isKnownUniquelyReferenced(&cache) {
      self.cache = cache.copy()
    }
    cache.set(key, to: value)
    invalidate(keys: key.dependentKeys)
  }
  
  private mutating func invalidate(keys: [SkinKey]) {
    keys.forEach { key in
      cache.remove(key)
      invalidate(keys: key.dependentKeys)
    }
  }
  
  public func interpolated(to toSkin: Skin, at frac: Frac) -> Skin {
    return InterpolatedSkin(skin1: self, skin2: toSkin, frac: frac)
  }
}
