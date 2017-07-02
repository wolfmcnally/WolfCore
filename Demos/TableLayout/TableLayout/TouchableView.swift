//
//  TouchableView.swift
//  TableLayout
//
//  Created by Robert McNally on 7/6/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore
import WolfBase

class TouchableView: View {
  var touchAction: Block?
  private var tapAction: GestureRecognizerAction!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    tapAction = addAction(forGestureRecognizer: UITapGestureRecognizer()) { _ in
      self.touchAction?()
    }
  }
}
