//
//  ValueCache.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/10/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public final class ValueCache {
  private typealias `Self` = ValueCache
  private typealias Dict = [AnyHashable : Any]
  private var d: Dict
  
  public init() {
    d = Dict()
  }
  
  private init(d: Dict) {
    self.d = d
  }
  
  public func copy() -> ValueCache {
    return Self.init(d: d)
  }
  
  public func set<T>(_ key: AnyHashable, to value: T) {
    d[key] = value
  }
  
  public func get<T>(_ key: AnyHashable) -> T? {
    return d[key] as? T
  }
  
  public func get<T>(_ key: AnyHashable, with update: () -> T) -> T {
    if let value = d[key] {
      return value as! T
    } else {
      let value = update()
      d[key] = value
      return value
    }
  }
  
  public func remove(_ key: AnyHashable) {
    d[key] = nil
  }
}
