//
//  IntSize.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/20/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public struct IntSize {
    public var width: Int
    public var height: Int

    public init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }
}

extension IntSize: CustomStringConvertible {
    public var description: String {
        return("IntSize(\(width), \(height))")
    }
}

extension IntSize {
    public static let zero = IntSize()
}

extension IntSize: Equatable {
}

extension IntSize: Codable {
}

public func == (lhs: IntSize, rhs: IntSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}
