//
//  TopSkin.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public var lightSkin: Skin = {
  var skin = ConcreteSkin()
  skin.applyDefaults()
  return skin
}()

public var darkSkin: Skin = {
  var skin = ConcreteSkin()
  skin.applyDarkDefaults()
  return skin
}()

public var topSkin: Skin = lightSkin {
  didSet {
    syncToTopSkin()
  }
}

public func syncToTopSkin() {
  #if !os(tvOS)
    UIBarButtonItem.appearance().setTitleTextAttributes([.font : topSkin.barbuttonTitleStyle.font], for: .normal)
  #endif
}
