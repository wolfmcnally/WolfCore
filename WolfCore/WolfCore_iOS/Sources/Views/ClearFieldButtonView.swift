//
//  ClearFieldButtonView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/19/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class ClearFieldButtonView: View {
  public private(set) lazy var button: ClearFieldButton = {
    let button = ClearFieldButton()
    return button
  }()
  
  public override func setup() {
    super.setup()
    self => [
      button
    ]
    let image = button.image(for: .normal)!
    let size = image.size
    Constraints(
      button.centerXAnchor == centerXAnchor,
      button.centerYAnchor == centerYAnchor,
      
      widthAnchor == size.width,
      heightAnchor == size.height
    )
  }
  
  public func conceal(animated: Bool) {
    if isShown {
      dispatchAnimated(animated) {
        self.button.alpha = 0
        }.then { _ in
          self.hide()
        }.run()
    }
  }
  
  public func reveal(animated: Bool) {
    if isHidden {
      self.show()
      dispatchAnimated(animated) {
        self.button.alpha = 1
        }.run()
    }
  }
}

public class ClearFieldButton: Button {
  public override func setup() {
    super.setup()
    
    let image = UIImage.init(named: "clearFieldButton", in: Framework.bundle)
    setImage(image, for: .normal)
    setPriority(hugH: .required, hugV: .required)
  }
}
