//
//  MyTableViewCell.swift
//  TableLayout
//
//  Created by Robert McNally on 7/6/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore
import WolfBase

class MyTableViewCell: TableViewCell {
  @IBOutlet weak var coloredView: TouchableView!
  @IBOutlet weak var coloredViewWidth: NSLayoutConstraint!
  @IBOutlet weak var coloredViewHeight: NSLayoutConstraint!
  @IBOutlet weak var indexLabel: Label!

  var touchAction: Block?

  var model: Model! {
    didSet {
      syncToModel()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    coloredView.touchAction = { [unowned self] in
      self.touchAction?()
    }
  }

  override func updateConstraints() {
    super.updateConstraints()
    coloredViewWidth.constant = model.size.width
    coloredViewHeight.constant = model.size.height
  }

  fileprivate func syncToModel() {
    setNeedsUpdateConstraints()
    indexLabel.text = String(model.index)
    applySkin(skin)
  }

  override func applySkin(_ skin: Skin) {
    super.applySkin(skin)
    coloredView.skin.viewBackgroundColor = model.color

    let color: Color = model.color.luminance < 0.5 ? .white : .black
    indexLabel.skin.labelStyle = skin.titleStyle.withColor(color)
  }
}
