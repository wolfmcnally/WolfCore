//
//  Slider.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/19/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class Slider: UISlider, Skinnable {
  public convenience init() {
    self.init(frame: .zero)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    _setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
  }
  
  private func _setup() {
    __setup()
    setup()
  }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
    thumbTintColor ©= skin.sliderThumbColor
    minimumTrackTintColor ©= skin.sliderMinTrackColor
    maximumTrackTintColor ©= skin.sliderMaxTrackColor
  }
  
  open func setup() { }
}
