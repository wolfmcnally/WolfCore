//
//  CGUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/22/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

public typealias CGContextBlock = (CGContext) -> Void

public func drawInto(_ context: CGContext, drawing: CGContextBlock) {
  context.saveGState()
  drawing(context)
  context.restoreGState()
}

public func drawIntoCurrentContext(drawing: CGContextBlock) {
  drawInto(currentGraphicsContext, drawing: drawing)
}

public var currentGraphicsContext: CGContext {
  #if os(macOS)
    return NSGraphicsContext.current!.cgContext
  #else
    return UIGraphicsGetCurrentContext()!
  #endif
}

public func drawPlaceholderRect(_ rect: CGRect, lineWidth: CGFloat = 1.0, color: OSColor? = OSColor(white: 0.5, alpha: 0.5)) {
  drawIntoCurrentContext() { context in
    context.setLineWidth(lineWidth)
    if let color = color {
      context.setStrokeColor(color.cgColor)
    }
    let rect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
    context.stroke(rect)
    context.setLineCap(.round)
    let path = OSBezierPath()
    path.move(to: rect.minXminY)
    path.addLine(to: rect.maxXmaxY)
    path.move(to: rect.maxXminY)
    path.addLine(to: rect.minXmaxY)
    path.stroke()
  }
}

//extension CGFloat: JSONRepresentable {
//    public var json: JSON { return JSON(Double(self)) }
//}

