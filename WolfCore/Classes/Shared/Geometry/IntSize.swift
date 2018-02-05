//
//  IntSize.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/20/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public struct IntSize {
    public var width: Int = 0
    public var height: Int = 0
}

extension IntSize: CustomStringConvertible {
    public var description: String {
        return("IntSize(\(width), \(height))")
    }
}

extension IntSize : Equatable {
}

public func == (lhs: IntSize, rhs: IntSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}
