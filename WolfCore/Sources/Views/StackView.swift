//
//  StackView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/26/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
import Foundation

open class StackView: OSStackView, Skinnable, Editable {
  public var isTransparentToTouches = false
  public var isEditing = false

  public convenience init() {
    self.init(frame: .zero)
  }

  public convenience init(arrangedSubviews views: [OSView]) {
    self.init(arrangedSubviews: views)
    _setup()
  }

  public func syncToEditing(animated: Bool) {
    for view in arrangedSubviews {
      if let editableView = view as? Editable {
        editableView.setEditing(isEditing, animated: animated)
      }
    }
    adjustToContentHeightChanges(animated: animated)
  }

  public func adjustToContentHeightChanges(animated: Bool) {
    //setNeedsLayout()
    guard arrangedSubviews.count > 0 else { return }
    dispatchAnimated(animated) {
      // KLUDGE: As long as at least one arranged subview changes it's hidden status,
      // the stack view will pick up and properly animated size changes of its other subviews.
      // So here we simply toggle the first arranged subview's hidden status twice.
      let view = self.arrangedSubviews[0]
      view.isHidden = !view.isHidden
      view.isHidden = !view.isHidden

      self.layoutIfNeeded()
      }.run()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    _setup()
  }

  #if os(macOS)
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    _setup()
  }
  #else
  public required init(coder: NSCoder) {
    super.init(coder: coder)
    _setup()
  }
  #endif

  private func _setup() {
    __setup()
    setup()
  }

  #if !os(macOS)
  open override func point(inside point: CGPoint, with event: OSEvent?) -> Bool {
    if isTransparentToTouches {
      return isTransparentToTouch(at: point, with: event)
    } else {
      return super.point(inside: point, with: event)
    }
  }
  #endif

  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }

  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
  }

  open func setup() { }
}

