//
//  Vector.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/15/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
    import CoreGraphics
#elseif os(Linux)
    import Glibc
#endif

import Foundation

public struct Vector {
    public var dx: Double = 0
    public var dy: Double = 0
    
    public init() {
        dx = 0
        dy = 0
    }
    
    public init(dx: Double, dy: Double) {
        self.dx = dx
        self.dy = dy
    }
}

#if os(iOS) || os(macOS) || os(tvOS)
    extension Vector {
        public init(v: CGVector) {
            dx = Double(v.dx)
            dy = Double(v.dy)
        }
        
        public var cgVector: CGVector {
            return CGVector(dx: CGFloat(dx), dy: CGFloat(dy))
        }
    }
#endif

extension Vector: CustomStringConvertible {
    public var description: String {
        return("Vector(\(dx), \(dy))")
    }
}

extension Vector {
    public static let zero = Vector()
    
    public init(dx: Int, dy: Int) {
        self.dx = Double(dx)
        self.dy = Double(dy)
    }
    
    public init(dx: Float, dy: Float) {
        self.dx = Double(dx)
        self.dy = Double(dy)
    }
}

extension Vector {
    public init(_ point1: Point, _ point2: Point) {
        dx = point2.x - point1.x
        dy = point2.y - point1.y
    }
    
    public init(point: Point) {
        dx = point.x
        dy = point.y
    }
    
    public init(size: Size) {
        dx = size.width
        dy = size.height
    }
    
    public var magnitude: Double {
        return hypot(dx, dy)
    }
    
    public var angle: Double {
        return atan2(dy, dx)
    }
    
    public var normalized: Vector {
        let m = magnitude
        assert(m > 0.0)
        return self / m
    }
    
    public mutating func normalize() {
        self = self.normalized
    }
    
    public func rotated(by theta: Double) -> Vector {
        let sinTheta = sin(theta)
        let cosTheta = cos(theta)
        return Vector(dx: dx * cosTheta - dy * sinTheta, dy: dx * sinTheta + dy * cosTheta)
    }
    
    public mutating func rotate(byAngle theta: Double) {
        self = rotated(by: theta)
    }
    
    public static var unit = Vector(dx: 1, dy: 0)
}

extension Vector: Equatable {
}

public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.dx == rhs.dx && lhs.dy == rhs.dy
}

public func / (lhs: Vector, rhs: Double) -> Vector {
    return Vector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

public func / (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
}

public func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

public func * (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
}

public func dot(_ v1: Vector, _ v2: Vector) -> Double {
    return v1.dx * v2.dx + v1.dy * v2.dy
}

public func cross(_ v1: Vector, _ v2: Vector) -> Double {
    return v1.dx * v2.dy - v1.dy * v2.dx
}
