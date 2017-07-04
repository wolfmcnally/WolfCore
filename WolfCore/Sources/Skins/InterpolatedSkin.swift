//
//  InterpolatedSkin.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/11/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

public struct InterpolatedSkin: Skin {
  public var cache = ValueCache<SkinKey>()
  public let skin1: Skin
  public let skin2: Skin
  public let frac: Frac
  
  public init(skin1: Skin, skin2: Skin, frac: Frac) {
    self.skin1 = skin1
    self.skin2 = skin2
    self.frac = frac
    resetIdentifierPath("interpolation from \(skin1.identifierPath) to /\(skin2.identifierPath) at \(frac %% 3)")
  }
  
  public func get<T: SkinValue>(_ key: SkinKey, _ update: @autoclosure () -> T) -> T {
    return cache.get(key) {
      let v1: T = skin1.get(key, update)
      let v2: T = skin2.get(key, update)
      return v1.interpolated(to: v2, at: frac)
    }
  }
  
  public mutating func set<T: SkinValue>(_ key: SkinKey, to value: T) {
    cache.set(key, to: value)
  }
  
  public func interpolated(to toSkin: Skin, at frac: Frac) -> Skin {
    return InterpolatedSkin(skin1: self, skin2: toSkin, frac: frac)
  }
}
