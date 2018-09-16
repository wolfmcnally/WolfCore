//
//  DataExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation
import WolfPipe
import WolfStrings

// Support the Serializable protocol used for caching

extension Data: Serializable {
    public typealias ValueType = Data

    public func serialize() -> Data {
        return self
    }

    public static func deserialize(from data: Data) throws -> Data {
        return data
    }

    public init(bytes: Slice<Data>) {
        self.init(bytes: Array(bytes))
    }
}

public func printDataAsString(_ data: Data) {
    print(String(data: data, encoding: .utf8)!)
}
