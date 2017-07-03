//
//  TopSkin-macOS.swift
//  WolfCore_macOS
//
//  Created by Wolf McNally on 7/3/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Cocoa

public var lightSkin: Skin = {
  var skin = ConcreteSkin()
  skin.applyDefaults()
  return skin
}()

public var topSkin: Skin = lightSkin {
  didSet {
    syncToTopSkin()
  }
}

public func syncToTopSkin() {
}

