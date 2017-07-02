//
//  DevOverlayView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/26/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public var devOverlay = DevOverlayView()

public class DevOverlayView: View {
  public override func setup() {
    super.setup()

    let window = UIApplication.shared.windows[0]
    window => [
      self
    ]
    isTransparentToTouches = true
    bounds = window.frame
    constrainFrameToFrame(identifier: "DevOverlay")
    dispatchRepeatedOnMain(atInterval: 0.2) { canceler in
      window.bringSubview(toFront: self)
    }
  }
}
