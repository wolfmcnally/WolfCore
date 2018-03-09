//
//  Point.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/15/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Represents a 2-dimensional point, with Double precision.
public struct Point {
    public var x: Double = 0
    public var y: Double = 0

    public init() {
        x = 0
        y = 0
    }

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Point {
    /// Provides conversion from Vector.
    public init(vector: Vector) {
        x = vector.dx
        y = vector.dy
    }

    /// Provides conversion from polar coordinates.
    ///
    /// - Parameter center: The `Point` to be considered as the origin.
    ///
    /// - Parameter angle: The angle from the angular origin, in radians.
    ///
    /// - Parameter radius: The distance from the origin, as scalar units.
    public init(center: Point, angle theta: Double, radius: Double) {
        x = center.x + cos(theta) * radius
        y = center.y + sin(theta) * radius
    }

    public var magnitude: Double {
        return hypot(x, y)
    }

    public var angle: Double {
        return atan2(y, x)
    }

    public func rotated(by theta: Double, aroundCenter center: Point) -> Point {
        let v = center - self
        let v2 = v.rotated(by: theta)
        let p = center + v2
        return p
    }
}

extension Point: CustomStringConvertible {
    public var description: String {
        return("Point(\(x), \(y))")
    }
}

extension Point {
    public static let zero = Point()
    public static let infinite = Point(x: Double.infinity, y: Double.infinity)

    public init(x: Int, y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }

    public init(x: Float, y: Float) {
        self.x = Double(x)
        self.y = Double(y)
    }
}

extension Point {
    public func toNormalizedCoordinates(fromSize size: Size) -> Point {
        let nx = x.lerped(from: 0..size.width, to: -1..1)
        let ny = y.lerped(from: 0..size.height, to: -1..1)
        return Point(x: nx, y: ny)
    }

    public func fromNormalizedCoordinates(toSize size: Size) -> Point {
        let nx = x.lerped(from: -1..1, to: 0..size.width)
        let ny = y.lerped(from: -1..1, to: 0..size.height)
        return Point(x: nx, y: ny)
    }

    public func transformCoordinates(fromSize: Size, toSize: Size) -> Point {
        let nx = x.lerped(from: 0..fromSize.width, to: 0..toSize.width)
        let ny = y.lerped(from: 0..fromSize.height, to: 0..toSize.height)
        return Point(x: nx, y: ny)
    }
}

extension Point: Equatable {
    static public func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public func - (lhs: Point, rhs: Point) -> Vector {
    return Vector(dx: rhs.x - lhs.x, dy: rhs.y - lhs.y)
}

public func + (lhs: Point, rhs: Vector) -> Point {
    return Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

public func += (lhs: inout Point, rhs: Vector) {
    lhs = lhs + rhs
}

public func - (lhs: Point, rhs: Vector) -> Point {
    return Point(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

public func -= (lhs: inout Point, rhs: Vector) {
    lhs = lhs - rhs
}

public func + (lhs: Vector, rhs: Point) -> Point {
    return Point(x: lhs.dx + rhs.x, y: lhs.dy + rhs.y)
}

public func - (lhs: Vector, rhs: Point) -> Point {
    return Point(x: lhs.dx - rhs.x, y: lhs.dy - rhs.y)
}
