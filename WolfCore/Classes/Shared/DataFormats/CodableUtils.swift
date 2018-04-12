//
//  CodableUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 8/21/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(key: Key) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
}

extension UnkeyedDecodingContainer {
    public mutating func decode<T: Decodable>() throws -> T {
        return try self.decode(T.self)
    }
}

//precedencegroup ContainerPrecedence {
//    associativity: right
//    higherThan: BitwiseShiftPrecedence
//}
//
//infix operator <== : ContainerPrecedence
//
//public func <== <NestedKey, Key>(lhs: KeyedDecodingContainer<Key>, rhs: Key) -> (KeyedDecodingContainer<Key>, Key) {
//    return (lhs, rhs)
//}
//
//infix operator |*| : ContainerPrecedence
//infix operator |*|? : ContainerPrecedence
//
//postfix operator |*|
//
///// Retrieves a `KeyedDecodingContainer` from a `Decoder`.
//public func |*| <Key>(lhs: Decoder, rhs: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
//    return try lhs.container(keyedBy: rhs)
//}
//
///// Retrieves a nested `KeyedDecodingContainer` from a `Decoder` at the given `Key`.
//public func |*| <NestedKey, Key>(lhs: KeyedDecodingContainer<Key>, rhs: (NestedKey.Type, Key)) throws -> KeyedDecodingContainer<NestedKey> {
//    return try lhs.nestedContainer(keyedBy: rhs.0, forKey: rhs.1)
//}
//
///// Retrieves a nested `UnkeyedDecodingContainer` from a `Decoder` at the given `Key`.
//public func |*| <Key>(lhs: KeyedDecodingContainer<Key>, rhs: Key) throws -> UnkeyedDecodingContainer {
//    return try lhs.nestedUnkeyedContainer(forKey: rhs)
//}
//
///// Reads a `KeyedEncodingContainer` from an `Encoder`.
//public func |*| <Key>(lhs: Encoder, rhs: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
//    return lhs.container(keyedBy: rhs)
//}
//
//
//public postfix func |*| <T: Decodable>(rhs: UnkeyedDecodingContainer) throws -> T {
//    var r = rhs
//    return try r.decode(T.self)
//}
//
///// Reads an optional value from a `KeyedDecodingContainer`. Returns `nil` if the key does not exist or is JSON `null`.
//public func |*|? <Key, T>(lhs: KeyedDecodingContainer<Key>, rhs: Key) throws -> T? where T: Decodable {
//    guard lhs.contains(rhs) else { return nil }
//    return try lhs.decode(T.self, forKey: rhs)
//}
//
///// Reads a non-optional value from a `KeyedDecodingContainer`.
//public func |*| <Key, T>(lhs: KeyedDecodingContainer<Key>, rhs: Key) throws -> T where T: Decodable {
//    return try lhs.decode(T.self, forKey: rhs)
//}
//
///// Writes a value to a `KeyedEncodingContainer`. If the value is `nil` then nothing is written to the container.
//public func |*| <Key, T>(lhs: inout KeyedEncodingContainer<Key>, rhs: (T?, Key)) throws where T: Encodable {
//    guard let value = rhs.0 else { return }
//    try lhs.encode(value, forKey: rhs.1)
//}
//
///// Writes a value to a `KeyedEncodingContainer`. If the value is `nil` then JSON `null` is written to the container.
//public func |*|? <Key, T>(lhs: inout KeyedEncodingContainer<Key>, rhs: (T?, Key)) throws where T: Encodable {
//    try lhs.encode(rhs.0, forKey: rhs.1)
//}

// Example:
//
//    struct Person: Codable {
//        var name: String
//        var age: Int?
//
//        init(name: String, age: Int? = nil) {
//            self.name = name
//            self.age = age
//        }
//
//        enum CodingKeys: String, CodingKey {
//            case name
//            case age
//        }
//
//        func encode(to encoder: Encoder) throws {
//            try encoder |*| CodingKeys.self •• {
//                try $0 |*| (name, .name)
//                try $0 |*| (age, .age)
//            }
//        }
//
//        init(from decoder: Decoder) throws {
//            self.init(name: "", age: nil)
//            try decoder |*| CodingKeys.self •• {
//                name = try $0 |*| .name
//                age = try $0 |*|? .age
//            }
//        }
//    }
//
//    do {
//        let wolf = Person(name: "Wolf")
//        print(wolf)
//
//        let data = try JSONEncoder().encode(wolf)
//        print(String(data: data, encoding: .utf8)!)
//
//        let wolf2 = try JSONDecoder().decode(Person.self, from: data)
//        print(wolf2)
//    } catch {
//        print(error)
//    }
//
// Prints:
//
//    Person(name: "Wolf", age: nil)
//    {"name":"Wolf"}
//    Person(name: "Wolf", age: nil)



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
