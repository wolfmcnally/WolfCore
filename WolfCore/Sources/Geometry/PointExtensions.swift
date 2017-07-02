//
//  PointExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/12/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
import WolfBase

extension CGPoint {
  public init(vector: CGVector) {
    x = vector.dx
    y = vector.dy
  }
  
  public init(center: CGPoint, angle theta: CGFloat, radius: CGFloat) {
    x = center.x + cos(theta) * radius
    y = center.y + sin(theta) * radius
  }
  
  public var magnitude: CGFloat {
    return hypot(x, y)
  }
  
  public var angle: CGFloat {
    return atan2(y, x)
  }
  
  public func rotated(by theta: CGFloat, aroundCenter center: CGPoint) -> CGPoint {
    let v = center - self
    let v2 = v.rotated(by: theta)
    let p = center + v2
    return p
  }
}

extension CGPoint {
  public var debugSummary: String {
    let joiner = Joiner(left: "(", right: ")")
    joiner.append(x %% 3, y %% 3)
    return joiner.description
  }
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGVector {
  return CGVector(dx: lhs.x + rhs.x, dy: lhs.y + rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
  return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

public func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

public func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

public func + (lhs: CGVector, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.dx + rhs.x, y: lhs.dy + rhs.y)
}

public func - (lhs: CGVector, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.dx - rhs.x, y: lhs.dy - rhs.y)
}

extension Point {
  /// Provides conversion from CoreGraphics CGPoint types.
  public init(cgPoint p: CGPoint) {
    x = Double(p.x)
    y = Double(p.y)
  }
  
  /// Provides conversion to CoreGraphics CGPoint types.
  public var cgPoint: CGPoint {
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
  }
}
