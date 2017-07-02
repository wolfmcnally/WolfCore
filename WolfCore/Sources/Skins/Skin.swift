//
//  Skin.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/10/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

public protocol Skin {
  var identifierPath: String { get }
  mutating func addIdentifier(_ id: String)
  mutating func resetIdentifierPath(_ id: String)
  
  func get<T: SkinValue>(_ key: SkinKey, _ update: @autoclosure () -> T) -> T
  mutating func set<T: SkinValue>(_ key: SkinKey, to value: T)
  func interpolated(to toSkin: Skin, at frac: Frac) -> Skin
}

extension SkinKey {
  public static let identifierPath = SkinKey("identifierPath")
  public static let variant = SkinKey("variant")
}

extension Skin {
  public mutating func addIdentifier(_ id: String) {
    let path = identifierPath
    guard !path.hasSuffix(id) else { return }
    identifierPath = path + "/\(id)"
  }
  
  public mutating func resetIdentifierPath(_ id: String) {
    identifierPath = id
  }
  
  public private(set) var identifierPath: String {
    get { return get(.identifierPath, "skin") }
    set { set(.identifierPath, to: newValue) }
  }
  
  public var variant: SkinVariant {
    get { return get(.variant, .lightBackground) }
    set { set(.variant, to: newValue) }
  }
}

public enum SkinVariant {
  case lightBackground
  case darkBackground
}

extension SkinVariant: SkinValue {
  public func interpolated(to other: SkinVariant, at frac: Frac) -> SkinVariant {
    return frac.ledge(self, other)
  }
}
