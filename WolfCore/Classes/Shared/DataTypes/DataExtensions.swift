//
//  DataExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

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

extension Data {
    public init(string: String) {
        self.init(utf8: string |> UTF8.init)
    }
}

public func printDataAsString(_ data: Data) {
    print(String(data: data, encoding: .utf8)!)
}
