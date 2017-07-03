//
//  Skin.swift
//  WolfCore_macOS
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Cocoa

extension SkinKey {
  //    public static let variant = SkinKey("variant")
}

extension Skin {
  //    public var variant: SkinVariant {
  //        get { return get(.variant) as SkinVariant }
  //        set { set(.variant, to: newValue) }
  //    }
}

extension ConcreteSkin {
  public mutating func applyDefaults() {
    addIdentifier("light")
  }
}

