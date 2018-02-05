//
//  RunningAverage.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/16/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public class RunningAverage<T: BinaryFloatingPoint> {
    public private(set) var value: T?
    
    public init() { }
    
    public func update(_ newValue: T) {
        guard let oldValue = value else { value = newValue; return }
        value = (oldValue + newValue) / 2
    }
}
