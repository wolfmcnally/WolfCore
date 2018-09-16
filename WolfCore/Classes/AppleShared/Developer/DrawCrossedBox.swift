//
//  DrawCrossedBox.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/18/17.
//  Copyright © 2017 WolfMcNally.com.
//

import CoreGraphics
import WolfColor

public func drawCrossedBox(into context: CGContext, frame: CGRect, color: OSColor = .red, lineWidth: CGFloat = 1, showOriginIndicators: Bool = true) {
    let insetFrame = frame.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
    drawInto(context) { context in
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.stroke(insetFrame)
        context.move(to: insetFrame.minXminY)
        context.addLine(to: insetFrame.maxXmaxY)
        context.move(to: insetFrame.minXmaxY)
        context.addLine(to: insetFrame.maxXminY)
        if showOriginIndicators {
            context.move(to: insetFrame.midXmidY)
            context.addLine(to: insetFrame.midXminY)
            context.move(to: insetFrame.midXmidY)
            context.addLine(to: insetFrame.minXmidY)
        }
        context.strokePath()
    }
}

public func drawCrossedBox(into context: CGContext, size: CGSize, color: OSColor = .red, lineWidth: CGFloat = 1, showOriginIndicators: Bool = true) {
    let frame = CGRect(origin: .zero, size: size)
    drawCrossedBox(into: context, frame: frame, color: color, lineWidth: lineWidth, showOriginIndicators: showOriginIndicators)
}

public func drawDot(into context: CGContext, at point: CGPoint, radius: CGFloat = 2.0, color: OSColor = .red) {
    let r = CGRect(origin: point, size: .zero).insetBy(dx: -radius, dy: -radius)
    drawInto(context) { context in
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: r)
    }
}
