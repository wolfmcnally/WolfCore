//
//  PageControl.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class PageControl: UIPageControl, Skinnable {
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
  
  open func setup() { }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
    pageIndicatorTintColor ©= skin.pageIndicatorTintColor
    currentPageIndicatorTintColor ©= skin.currentPageIndicatorTintColor
  }
}
