//
//  ConicalGradient.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
import WolfBase

public class ConicalGradient {
  public var colorFunc: ColorFunc!
  public var startAngle: CGFloat = 0
  public var endAngle: CGFloat = 2 * .pi
  public var radialWidth: CGFloat?
  public var stepFactor: CGFloat = 2

  public init() {
  }

  public func draw(into context: CGContext, at center: CGPoint, radius: CGFloat) {
    drawInto(context) { context in
      let step = (CGFloat.pi / 2) / radius * stepFactor
      let subtendedAngle = endAngle - startAngle
      let laps = floor(subtendedAngle / (.pi * 2))

      var angle1 = laps == 0 ? startAngle : endAngle - (.pi * 2)
      let innerRadius: CGFloat
      if let radialWidth = radialWidth {
        innerRadius = radius - radialWidth
      } else {
        innerRadius = 0
      }
      while angle1 < endAngle {
        let angle2 = min(angle1 + step, endAngle)

        let spread: CGFloat = 0.0005
        let a1 = angle1 - spread
        let a2 = angle2 + spread
        let innerPoint1 = center + CGVector(angle: a1, magnitude: innerRadius)
        let innerPoint2 = center + CGVector(angle: a2, magnitude: innerRadius)
        let outerPoint1 = center + CGVector(angle: a1, magnitude: radius)
        let outerPoint2 = center + CGVector(angle: a2, magnitude: radius)

        let path = CGMutablePath()
        path.move(to: innerPoint2)
        path.addLine(to: innerPoint1)
        path.addLine(to: outerPoint1)
        path.addLine(to: outerPoint2)
        path.closeSubpath()

        let frac = Frac(angle1.lerpedToFrac(from: startAngle..endAngle))
        let color = colorFunc(frac).cgColor
        context.setFillColor(color)
        context.addPath(path)
        context.fillPath()

        angle1 = angle2
      }
    }
  }
}

//public func draw(into context: CGContext, at center: CGPoint, radius: CGFloat) {
//    drawInto(context) { context in
//        let step = CGFloat(M_PI_2) / radius * stepFactor
//        let subtendedAngle = endAngle - startAngle
//        let laps = floor(subtendedAngle / (.pi * 2))
//
//        var angle1 = laps == 0 ? startAngle : endAngle - (.pi * 2)
//        var outerPoint1 = center + CGVector(angle: angle1, magnitude: radius)
//        var innerPoint1: CGPoint
//        var innerRadius: CGFloat?
//        if let radialWidth = radialWidth {
//            innerRadius = radius - radialWidth
//            innerPoint1 = center + CGVector(angle: angle1, magnitude: innerRadius!)
//        } else {
//            innerPoint1 = center
//        }
//        var wedgeCount = 0
//        while angle1 < endAngle {
//            let angle2 = min(angle1 + step, endAngle)
//            let outerPoint2 = center + CGVector(angle: angle2, magnitude: radius)
//            var innerPoint2: CGPoint?
//            if let innerRadius = innerRadius {
//                innerPoint2 = center + CGVector(angle: angle2, magnitude: innerRadius)
//            }
//
//            let path = CGMutablePath()
//            if let innerPoint2 = innerPoint2 {
//                path.move(to: innerPoint2)
//                path.addLine(to: innerPoint1)
//            } else {
//                path.move(to: innerPoint1)
//            }
//            path.addLine(to: outerPoint1)
//            path.addLine(to: outerPoint2)
//            path.closeSubpath()
//
//            let frac = Frac(angle1.mapped(from: startAngle..endAngle))
//            let color = colorFunc(frac).cgColor
//            context.setFillColor(color)
//            context.addPath(path)
//            context.fillPath()
//
//            //                context.setLineWidth(0.05)
//            //                context.setStrokeColor(color)
//            //                context.addPath(path)
//            //                context.strokePath()
//
//            angle1 = angle2
//            outerPoint1 = outerPoint2
//            if let innerPoint2 = innerPoint2 {
//                innerPoint1 = innerPoint2
//            }
//
//            wedgeCount += 1
//        }
//        //print("wedges: \(wedgeCount), laps: \(laps)")
//}
