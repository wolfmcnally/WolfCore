//
//  CollectionViewCell.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/27/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

open class CollectionViewCell: UICollectionViewCell, Skinnable {
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
  }
  
  open func setup() { }
}
