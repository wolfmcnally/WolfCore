//
//  Insets.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/16/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public struct Insets {
    public var top: Double?
    public var left: Double?
    public var bottom: Double?
    public var right: Double?
    
    public init(top: Double? = nil, left: Double? = nil, bottom: Double? = nil, right: Double? = nil) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    public init(size: Double) {
        self.init(top: size, left: size, bottom: size, right: size)
    }
    
    public static let zero = Insets(top: 0, left: 0, bottom: 0, right: 0)
}
