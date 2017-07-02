//
//  Skinnable.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/10/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public protocol Skinnable: class {
  var skin: Skin! { get set }
  func reviseSkin(_ skin: Skin) -> Skin?
  func applySkin(_ skin: Skin)
}
