//
//  TextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/1/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class TextField: UITextField, Skinnable {
  var tintedClearImage: UIImage?
  var lastTintColor: UIColor?
  public static var placeholderColor: UIColor?
  var placeholderColor: UIColor?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    _setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
  }
  
  public convenience init() {
    self.init(frame: .zero)
  }
  
  private func _setup() {
    __setup()
    setup()
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    updateClearButtonAppearance(from: skin)
  }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
    updateContentAppearance(from: skin)
    updateClearButtonAppearance(from: skin)
    updatePlaceholderAppearance(from: skin)
  }
  
  open func updateContentAppearance(from skin: Skin) {
    let style = skin.textFieldContentStyle
    font = style.font
    textColor ©= style.color
    attributedText = style.apply(to: text)
  }
  
  open func updateClearButtonAppearance(from skin: Skin) {
    let newTintColor = (skin.textFieldContentStyle.color ?? skin.textColor).osColor
    let buttons: [UIButton] = self.descendantViews()
    guard !buttons.isEmpty else { return }
    let button = buttons[0]
    guard let image = button.image(for: .highlighted) else { return }
    tintedClearImage = image.tinted(withColor: newTintColor)
    button.setImage(tintedClearImage, for: .normal)
    button.setImage(tintedClearImage, for: .highlighted)
    lastTintColor = newTintColor
  }
  
  open func updatePlaceholderAppearance(from skin: Skin) {
    guard let placeholder = placeholder else { return }
    let style = skin.textFieldPlaceholderStyle
    attributedPlaceholder = style.apply(to: placeholder)
  }
  
  open func setup() {
  }
  
  open override var text: String! {
    didSet {
      applySkin(skin)
    }
  }
}
