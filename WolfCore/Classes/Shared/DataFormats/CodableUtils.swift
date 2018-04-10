//
//  CodableUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 8/21/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

//extension Decoder {
//    public static func <| <Key>(lhs: Self, rhs: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
//        return try lhs.container(keyedBy: rhs)
//    }
//}

//extension Decoder {
//    public subscript<Key>(type: Key.Type) -> KeyedDecodingContainer<Key> where Key: CodingKey {
//        do {
//            return try self.container(keyedBy: type)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//}
//
//extension Encoder {
//    public subscript<Key>(type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
//        return self.container(keyedBy: type)
//    }
//}
//
//extension KeyedDecodingContainer {
//    public subscript<T>(key: Key) -> T? where T: Decodable {
//        guard contains(key) else { return nil }
//        do {
//            return try decode(T.self, forKey: key)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    public subscript<NestedKey>(type: NestedKey.Type, key: Key) -> KeyedDecodingContainer<NestedKey> {
//        do {
//            return try nestedContainer(keyedBy: type, forKey: key)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//}
//
//extension KeyedEncodingContainer {
//    public subscript<T>(key: Key) -> T? where T: Encodable {
//        get { fatalError("Cannot read from an encoding container") }
//        set {
//            guard let newValue = newValue else { return }
//            do {
//                try encode(newValue, forKey: key)
//            } catch {
//                fatalError(error.localizedDescription)
//            }
//        }
//    }
//}
