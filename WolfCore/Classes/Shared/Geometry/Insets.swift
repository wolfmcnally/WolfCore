//
//  Insets.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/16/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public struct Insets<T: BinaryFloatingPoint> {
    public var top: T?
    public var left: T?
    public var bottom: T?
    public var right: T?

    public init(top: T? = nil, left: T? = nil, bottom: T? = nil, right: T? = nil) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    public init(all n: T) {
        self.init(top: n, left: n, bottom: n, right: n)
    }

    public init(size: T) {
        self.init(top: size, left: size, bottom: size, right: size)
    }

    public static var zero: Insets { return Insets(top: 0, left: 0, bottom: 0, right: 0) }
}

#if !os(Linux)
    import CoreGraphics

    public typealias CGInsets = Insets<CGFloat>
#endif
