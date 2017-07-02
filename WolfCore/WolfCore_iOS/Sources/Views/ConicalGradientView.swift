//
//  ConicalGradientView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class ConicalGradientView: View {
  public var gradientLayer: ConicalGradientLayer { return layer as! ConicalGradientLayer }
  
  public override class var layerClass : AnyClass {
    return ConicalGradientLayer.self
  }
  
  public var gradient: ConicalGradient {
    return gradientLayer.gradient
  }
  
  public override func setup() {
    super.setup()
    layer.contentsScale = UIScreen.main.scale
    layer.drawsAsynchronously = true
    layer.needsDisplayOnBoundsChange = true
    layer.setNeedsDisplay()
  }
}
