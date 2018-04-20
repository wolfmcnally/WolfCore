//
//  TypedCoding.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/18/18.
//

import Foundation
extension CodingUserInfoKey {
    static let typedDecodeMap = CodingUserInfoKey(rawValue: "typedDecodeMap")!
}

public struct TypedEncodeMap {
    private var mappings: [ObjectIdentifier: String]

    public init(_ mappings: [ObjectIdentifier: String]) {
        self.mappings = mappings
    }

    subscript(o: ObjectIdentifier) -> String {
        guard let typeName = mappings[o] else {
            preconditionFailure("No typeName for type: \(o)")
        }
        return typeName
    }
}

public struct TypedDecodeMap<T: Decodable> {
    public typealias DecodeFunc = (KeyedDecodingContainer<TypedDecodingContainer<T>.CodingKeys>) throws -> T

    private var mappings: [String: DecodeFunc]

    public init(_ mappings: [String: DecodeFunc]) {
        self.mappings = mappings
    }

    subscript(s: String) -> DecodeFunc {
        guard let decodeFunc = mappings[s] else {
            preconditionFailure("No DecodeFunc for typeName: \(s)")
        }
        return decodeFunc
    }
}

struct TypedEncodingContainer<T: Encodable>: Encodable {
    let value: T
    let encodeMap: TypedEncodeMap

    enum CodingKeys: CodingKey {
        case type
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let typeName = encodeMap[ObjectIdentifier(type(of: value).self)]
        try container.encode(typeName, forKey: .type)
        try container.encode(value, forKey: .value)
    }
}

public struct TypedDecodingContainer<T: Decodable>: Decodable {
    let value: T

    public enum CodingKeys: CodingKey {
        case type
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .type)
        let decodeMap = decoder.userInfo[.typedDecodeMap] as! TypedDecodeMap<T>
        let decodeFunc = decodeMap[typeName]
        value = try decodeFunc(container)
    }
}

protocol FormatEncoder: class {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
    var userInfo: [CodingUserInfoKey : Any] { get set }

    func encodeTyped<T: Encodable>(_ object: T, encodeMap: TypedEncodeMap) throws -> Data
    func encodeTypedArray<T: Encodable>(_ array: [T], encodeMap: TypedEncodeMap) throws -> Data
    func encodeTypedCollection<T: Encodable>(_ collection: CodableTypedCollection<T>) throws -> Data
}

protocol FormatDecoder: class {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    var userInfo: [CodingUserInfoKey : Any] { get set }

    func decodeTyped<T: Decodable>(from data: Data, decodeMap: TypedDecodeMap<T>) throws -> T
    func decodeTypedArray<T: Decodable>(from data: Data, decodeMap: TypedDecodeMap<T>) throws -> [T]
    func decodeTypedCollection<T: Decodable>(from data: Data) throws -> CodableTypedCollection<T>
}

extension JSONEncoder: FormatEncoder { }
extension JSONDecoder: FormatDecoder { }

extension PropertyListEncoder: FormatEncoder { }
extension PropertyListDecoder: FormatDecoder { }

extension FormatEncoder {
    public func encodeTyped<T: Encodable>(_ object: T, encodeMap: TypedEncodeMap) throws -> Data {
        let typedObject = TypedEncodingContainer<T>(value: object, encodeMap: encodeMap)
        return try encode(typedObject)
    }

    public func encodeTypedArray<T: Encodable>(_ array: [T], encodeMap: TypedEncodeMap) throws -> Data {
        let typedArray = array.map { return TypedEncodingContainer<T>(value: $0, encodeMap: encodeMap) }
        return try encode(typedArray)
    }

    public func encodeTypedCollection<T: Encodable>(_ collection: CodableTypedCollection<T>) throws -> Data {
        let typedArray = collection.map { return TypedEncodingContainer<T>(value: $0, encodeMap: type(of: collection).encodeMap) }
        return try encode(typedArray)
    }
}

extension FormatDecoder {
    public func decodeTyped<T: Decodable>(from data: Data, decodeMap: TypedDecodeMap<T>) throws -> T {
        userInfo[.typedDecodeMap] = decodeMap
        let typedObject = try decode(TypedDecodingContainer<T>.self, from: data)
        return typedObject.value
    }

    public func decodeTypedArray<T: Decodable>(from data: Data, decodeMap: TypedDecodeMap<T>) throws -> [T] {
        userInfo[.typedDecodeMap] = decodeMap
        let typedArray = try decode([TypedDecodingContainer<T>].self, from: data)
        return typedArray.map { return $0.value }
    }

    public func decodeTypedCollection<C: CodableTypedCollection<T>, T: Decodable>(from data: Data) throws -> C {
        userInfo[.typedDecodeMap] = C.decodeMap
        let typedArray = try decode([TypedDecodingContainer<T>].self, from: data)
        let elements = typedArray.map { return $0.value }
        let collection = C()
        collection.elements = elements
        return collection
    }
}

open class CodableTypedCollection<ValueType: Codable>: Codable, RandomAccessCollection, RangeReplaceableCollection {
    public typealias ArrayType = [ValueType]

    var elements = ArrayType()

    private enum CodingKeys: CodingKey {
        case elements
    }

    // Sequence
    public typealias Iterator = ArrayType.Iterator
    public func makeIterator() -> IndexingIterator<ArrayType> {
        return elements.makeIterator()
    }

    // Collection
    public var startIndex: Int { return elements.startIndex }
    public var endIndex: Int { return elements.endIndex }

    // MutableCollection
    public subscript(i: Int) -> ValueType {
        get { return elements[i] }
        set { elements[i] = newValue }
    }

    // BidirectionalCollection
    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    public func index(before i: Int) -> Int {
        return elements.index(before: i)
    }

    // RangeReplaceableCollection
    public required init() { }

    public required init<S>(_ elements: S) where S : Sequence, S.Element == ValueType {
        self.elements.append(contentsOf: elements)
    }

    public func append<S>(contentsOf newElements: S) where S : Sequence, ValueType == S.Element {
        elements.append(contentsOf: newElements)
    }

    public func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, ValueType == C.Element, Int == R.Bound {
        return elements.replaceSubrange(subrange, with: newElements)
    }


    public init(_ elements: [ValueType]) {
        self.elements = elements
    }

    open class var encodeMap: TypedEncodeMap {
        fatalError("Override in subclass.")
    }

    open class var decodeMap: TypedDecodeMap<ValueType> {
        fatalError("Override in subclass.")
    }

    public func encode(to encoder: Encoder) throws {
        var arrayContainer = encoder.unkeyedContainer()
        let typedArray = elements.map { return TypedEncodingContainer<ValueType>(value: $0, encodeMap: type(of: self).encodeMap) }
        for element in typedArray {
            try arrayContainer.encode(element)
        }
    }

    public required init(from decoder: Decoder) throws {
        var arrayContainer = try decoder.unkeyedContainer()
        let decodeMap = type(of: self).decodeMap
        while !arrayContainer.isAtEnd {
            let container = try arrayContainer.nestedContainer(keyedBy: TypedDecodingContainer<ValueType>.CodingKeys.self)
            let typeName = try container.decode(String.self, forKey: .type)
            let decodeFunc = decodeMap[typeName]
            let value = try decodeFunc(container)
            elements.append(value)
        }
    }
}


// --------------------------------------------------------------------------------------------
// Working example
// --------------------------------------------------------------------------------------------

#if false

class Thing: Codable, CustomStringConvertible {
    var description: String {
        return "Thing()"
    }
}

class Person: Thing {
    var name: String
    var age: Int?

    enum CodingKeys: CodingKey {
        case name
        case age
    }

    init(name: String, age: Int?) {
        self.name = name
        self.age = age
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(age, forKey: .age)
    }

    override var description: String {
        return "Person(name: \(name), age: \(String(describing: age)))"
    }
}

class Place: Thing {
    var name: String
    var latitude: Double
    var longitude: Double

    enum CodingKeys: CodingKey {
        case name
        case latitude
        case longitude
    }

    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

    override var description: String {
        return "Place(name: \(name), latitude: \(latitude), longitude: \(longitude))"
    }
}

class ThingCollection: CodableTypedCollection<Thing>, CustomStringConvertible, ExpressibleByArrayLiteral {
    override class var encodeMap: TypedEncodeMap {
        return TypedEncodeMap( [
            ObjectIdentifier(Person.self): "Person",
            ObjectIdentifier(Place.self): "Place"
            ] )
    }

    override class var decodeMap: TypedDecodeMap<Thing> {
        return TypedDecodeMap<Thing>( [
            "Person": { return try $0.decode(Person.self, forKey: .value) },
            "Place": { return try $0.decode(Place.self, forKey: .value) }
            ] )
    }

    var description: String {
        let sa = elements.map { String(describing: $0) }
        let s = sa.joined(separator: ", ")
        return "ThingCollection(\(s))"
    }

    required init(arrayLiteral: Thing...) {
        super.init(arrayLiteral)
    }

    public required init<S>(_ elements: S) where Thing == S.Element, S : Sequence {
        super.init(elements)
    }

    public required init() {
        super.init()
    }

    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

struct ThingsAndStuff: Codable {
    var person: Person
    var place: Place
    var things: ThingCollection
}

// --------------------------------------------------------------------------------------------

func testTypedCoding() {
    let wolf = Person(name: "Wolf", age: 52)
    let luna = Person(name: "Luna", age: nil)
    let losAngeles = Place(name: "Los Angeles", latitude: 34.05, longitude: -118.24)
    let atlanta = Place(name: "Atlanta", latitude: 33.75, longitude: -84.39)
    let things: ThingCollection = [wolf, losAngeles]
    let thingsAndStuff = ThingsAndStuff(person: luna, place: atlanta, things: things)

    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let decoder = JSONDecoder()

        print("✳️ Heterogenous array:")
        things.forEach { print($0) }

        print("✳️ Heterogenous array encoded:")
        let encodedData = try encoder.encodeTypedCollection(things)
        print(String(data: encodedData, encoding: .utf8)!)

        print("✳️ Heterogenous array recovered:")
        let decodedThings: ThingCollection = try decoder.decodeTypedCollection(from: encodedData)
        decodedThings.forEach { print($0) }

        print("✳️ Complex data type including heterogenous array:")
        print(thingsAndStuff)

        print("✳️ Complex data type encoded:")
        let encodedComplexData = try encoder.encode(thingsAndStuff)
        print(String(data: encodedComplexData, encoding: .utf8)!)

        print("✳️ Complex data type recovered:")
        let decodedComplex = try decoder.decode(ThingsAndStuff.self, from: encodedComplexData)
        print(decodedComplex)
    } catch {
        print("🛑 \(error)")
    }
}

#endif

// Prints:
//
//    ✳️ Heterogenous array:
//    Person(name: Wolf, age: Optional(52))
//    Place(name: Los Angeles, latitude: 34.05, longitude: -118.24)
//    ✳️ Heterogenous array encoded:
//    [
//      {
//        "type" : "Person",
//        "value" : {
//          "name" : "Wolf",
//          "age" : 52
//        }
//      },
//      {
//        "type" : "Place",
//        "value" : {
//          "name" : "Los Angeles",
//          "longitude" : -118.23999999999999,
//          "latitude" : 34.049999999999997
//        }
//      }
//    ]
//    ✳️ Heterogenous array recovered:
//    Person(name: Wolf, age: Optional(52))
//    Place(name: Los Angeles, latitude: 34.05, longitude: -118.24)
//    ✳️ Complex data type including heterogenous array:
//    ThingsAndStuff(person: Person(name: Luna, age: nil), place: Place(name: Atlanta, latitude: 33.75, longitude: -84.39), things: ThingCollection(Person(name: Wolf, age: Optional(52)), Place(name: Los Angeles, latitude: 34.05, longitude: -118.24)))
//    ✳️ Complex data type encoded:
//    {
//      "place" : {
//        "name" : "Atlanta",
//        "longitude" : -84.390000000000001,
//        "latitude" : 33.75
//      },
//      "things" : [
//        {
//          "type" : "Person",
//          "value" : {
//            "name" : "Wolf",
//            "age" : 52
//          }
//        },
//        {
//          "type" : "Place",
//          "value" : {
//            "name" : "Los Angeles",
//            "longitude" : -118.23999999999999,
//            "latitude" : 34.049999999999997
//          }
//        }
//      ],
//      "person" : {
//        "name" : "Luna"
//      }
//    }
//    ✳️ Complex data type recovered:
//    ThingsAndStuff(person: Person(name: Luna, age: nil), place: Place(name: Atlanta, latitude: 33.75, longitude: -84.39), things: ThingCollection(Person(name: Wolf, age: Optional(52)), Place(name: Los Angeles, latitude: 34.05, longitude: -118.24)))
