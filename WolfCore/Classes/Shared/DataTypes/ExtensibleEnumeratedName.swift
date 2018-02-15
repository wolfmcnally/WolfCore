//
//  ExtensibleEnumeratedName.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/22/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public protocol ExtensibleEnumeratedName: RawRepresentable, Hashable, Comparable, CustomStringConvertible {
    associatedtype ValueType: Hashable, Comparable
    var rawValue: ValueType { get }
}

extension ExtensibleEnumeratedName {
    // Hashable
    public var hashValue: Int { return rawValue.hashValue }

    // RawRepresentable
    // You must still provide this constructor:
    //public init?(rawValue: ValueType?)

    // CustomStringConvertible
    public var description: String {
        return String(describing: rawValue)
    }
}

public func < <T: ExtensibleEnumeratedName>(left: T, right: T) -> Bool {
    return left.rawValue < right.rawValue
}
