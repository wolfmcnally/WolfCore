//
//  Serializable.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation
import WolfStrings
import WolfPipe

public protocol Serializable {
    associatedtype ValueType

    func serialize() -> Data
    static func deserialize(from data: Data) throws -> ValueType
}

extension String: Serializable {
    public typealias ValueType = String

    public func serialize() -> Data {
        return self |> toUTF8
    }

    public static func deserialize(from data: Data) throws -> String {
        return try data |> fromUTF8
    }
}
