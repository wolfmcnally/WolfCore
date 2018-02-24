//
//  CodableUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 8/21/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension Decoder {
    public subscript<Key>(type: Key.Type) -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return try! self.container(keyedBy: type)
    }
}

extension Encoder {
    public subscript<Key>(type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        return self.container(keyedBy: type)
    }
}

extension KeyedDecodingContainer {
    public subscript<T>(key: Key) -> T? where T: Decodable {
        guard contains(key) else { return nil }
        return try! decode(T.self, forKey: key)
    }

    public subscript<NestedKey>(type: NestedKey.Type, key: Key) -> KeyedDecodingContainer<NestedKey> {
        return try! nestedContainer(keyedBy: type, forKey: key)
    }
}

extension KeyedEncodingContainer {
    public subscript<T>(key: Key) -> T? where T: Encodable {
        get { fatalError("Cannot read from an encoding container") }
        set {
            guard let newValue = newValue else { return }
            try! encode(newValue, forKey: key)
        }
    }
}
