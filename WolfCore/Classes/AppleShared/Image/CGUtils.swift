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

public func flipContext(_ context: CGContext, height: CGFloat) {
    context.translateBy(x: 0.0, y: height)
    context.scaleBy(x: 1.0, y: -1.0)
}

public func drawInto(_ context: CGContext, isFlipped: Bool = false, bounds: CGRect? = nil, drawing: CGContextBlock) {
    context.saveGState()
    if isFlipped { flipContext(context, height: bounds!.height) }
    drawing(context)
    context.restoreGState()
}

public func drawIntoCurrentContext(isFlipped: Bool = false, bounds: CGRect? = nil, drawing: CGContextBlock) {
    drawInto(currentGraphicsContext, isFlipped: isFlipped, bounds: bounds, drawing: drawing)
}

public var currentGraphicsContext: CGContext {
    #if os(macOS)
        return NSGraphicsContext.current!.cgContext
    #else
        return UIGraphicsGetCurrentContext()!
    #endif
}

public func rotateContext(_ context: CGContext, by angle: CGFloat, around point: CGPoint) {
    context.concatenate(context.ctm.rotated(by: angle, around: point))
}

public func drawPlaceholderRect(_ rect: CGRect, lineWidth: CGFloat = 1.0, color: OSColor? = OSColor(white: 0.5, alpha: 0.5)) {
    drawIntoCurrentContext { context in
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
