//
//  Validation.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public protocol Validation {
    associatedtype Value
    var value: Value { get }
    var name: String { get }
}
