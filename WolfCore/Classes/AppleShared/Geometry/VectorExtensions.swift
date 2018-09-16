//
//  VectorExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/4/15.
//  Copyright © 2015 WolfMcNally.com.
//

import CoreGraphics

extension CGVector {
    public init(angle theta: CGFloat, magnitude: CGFloat) {
        self.init(dx: cos(theta) * magnitude, dy: sin(theta) * magnitude)
    }

    public init(_ point1: CGPoint, _ point2: CGPoint) {
        self.init(dx: point2.x - point1.x, dy: point2.y - point1.y)
    }

    public init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    public init(size: CGSize) {
        self.init(dx: size.width, dy: size.height)
    }

    public var magnitude: CGFloat {
        return hypot(dx, dy)
    }

    public var angle: CGFloat {
        return atan2(dy, dx)
    }

    public func normalized() -> CGVector {
        let m = magnitude
        assert(m > 0.0)
        return self / m
    }

    public func rotated(by theta: CGFloat) -> CGVector {
        let sinTheta = sin(theta)
        let cosTheta = cos(theta)
        return CGVector(dx: dx * cosTheta - dy * sinTheta, dy: dx * sinTheta + dy * cosTheta)
    }

    public static var unit = CGVector(dx: 1, dy: 0)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

public func / (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
}

public func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

public func * (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
}

public func dot(v1: CGVector, _ v2: CGVector) -> CGFloat {
    return v1.dx * v2.dx + v1.dy * v2.dy
}

public func cross(v1: CGVector, _ v2: CGVector) -> CGFloat {
    return v1.dx * v2.dy - v1.dy * v2.dx
}
