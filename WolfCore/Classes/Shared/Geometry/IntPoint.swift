//
//  IntPoint.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/20/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public struct IntPoint {
    public var x: Int
    public var y: Int

    public init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }
}

extension IntPoint: CustomStringConvertible {
    public var description: String {
        return("IntPoint(\(x), \(y))")
    }
}

extension IntPoint {
    public static let zero = IntPoint()
}

extension IntPoint: Equatable {
}

extension IntPoint: Codable {
}

public func == (lhs: IntPoint, rhs: IntPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
