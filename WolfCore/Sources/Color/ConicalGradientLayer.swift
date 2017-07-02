//
//  ConicalGradientLayer.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

import WolfBase

/**
 Subclass of `CALayer` which draws a conical gradient over its background color,
 filling the shape of the layer (i.e. including rounded corners).
 
 You can set colors and locations for the gradient.
 If no colors are set, default colors will be used.
 If no locations are set, colors will be equally distributed.
 */
public class ConicalGradientLayer: CALayer {
  public let gradient = ConicalGradient()
  
  public var colorFunc: ColorFunc {
    get {
      return gradient.colorFunc
    }
    set {
      gradient.colorFunc = newValue
      setNeedsDisplay()
    }
  }
  
  public var startAngle: CGFloat {
    get {
      return gradient.startAngle
    }
    set {
      gradient.startAngle = newValue
      setNeedsDisplay()
    }
  }
  
  public var endAngle: CGFloat {
    get {
      return gradient.endAngle
    }
    set {
      gradient.endAngle = newValue
      setNeedsDisplay()
    }
  }
  
  public var radialWidth: CGFloat? {
    get {
      return gradient.radialWidth
    }
    set {
      gradient.radialWidth = newValue
      setNeedsDisplay()
    }
  }
  
  public var stepFactor: CGFloat {
    get {
      return gradient.stepFactor
    }
    set {
      gradient.stepFactor = newValue
      setNeedsDisplay()
    }
  }
  
  public override func draw(in context: CGContext) {
    let rect = context.boundingBoxOfClipPath
    context.clear(rect)
    
    let center = rect.midXmidY
    let radius = rect.size.min / 2
    gradient.draw(into: context, at: center, radius: radius)
  }
}
