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
    public subscript<T>(key: Key) -> T where T: Decodable {
        return try! decode(T.self, forKey: key)
    }
    
    public subscript<NestedKey>(type: NestedKey.Type, key: Key) -> KeyedDecodingContainer<NestedKey> {
        return try! nestedContainer(keyedBy: type, forKey: key)
    }
}

extension KeyedEncodingContainer {
    public subscript<T>(key: Key) -> T where T: Encodable {
        get { fatalError() }
        set { try! encode(newValue, forKey: key) }
    }
    
    //  public subscript<NestedKey>(type: NestedKey.Type, key: Key) -> KeyedEncodingContainer<NestedKey> {
    //    return try! nestedContainer(keyedBy: type, forKey: key)
    //  }
}
