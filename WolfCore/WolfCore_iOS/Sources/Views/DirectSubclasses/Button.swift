//
//  Button.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import UIKit

open class Button: UIButton, Skinnable {
  open override func awakeFromNib() {
    super.awakeFromNib()
    setTitle(title(for: .normal)?.localized(onlyIfTagged: true), for: .normal)
  }
  
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
  
  open override func setTitle(_ title: String?, for state: UIControlState) {
    var title = title
    let attributedText = skin.buttonTitleStyle.apply(to: title)
    title = attributedText?.string
    super.setTitle(title, for: state)
  }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
    setTitleColor(tintColor, for: .normal)
    setTitleColor(skin.highlightedTintColor.osColor, for: .highlighted)
    setTitleColor(skin.disabledColor.osColor, for: .disabled)
    
    setTitle(title(for: .normal), for: .normal)
    
    guard let titleLabel = titleLabel else { return }
    titleLabel.font = skin.buttonTitleStyle.font
  }
  
  open func setup() { }
}
