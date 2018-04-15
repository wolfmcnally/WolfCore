//
//  CodableTypedCollection.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/14/18.
//

import Foundation

open class CodableTypedCollection<Element: Codable, ElementsKey: CodingKey, ElementTypeKey: CodingKey>: Codable, RandomAccessCollection, RangeReplaceableCollection {
    public typealias ArrayType = [Element]

    var elements = ArrayType()

    // Sequence
    public typealias Iterator = ArrayType.Iterator
    public func makeIterator() -> IndexingIterator<ArrayType> {
        return elements.makeIterator()
    }

    // Collection
    public var startIndex: Int { return elements.startIndex }
    public var endIndex: Int { return elements.endIndex }

    // MutableCollection
    public subscript(i: Int) -> Element {
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

    public required init<S>(_ elements: S) where S : Sequence, S.Element == Element {
        self.elements.append(contentsOf: elements)
    }

    public func append<S>(contentsOf newElements: S) where S : Sequence, Element == S.Element {
        elements.append(contentsOf: newElements)
    }

    public func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, Element == C.Element, Int == R.Bound {
        return elements.replaceSubrange(subrange, with: newElements)
    }

    public init(elements: [Element]) {
        self.elements = elements
    }

    public required init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: ElementsKey.self)
        var arrayContainerForType = try topContainer.nestedUnkeyedContainer(forKey: elementsKey)
        var arrayContainer = arrayContainerForType
        var elements = [Element]()
        while !arrayContainerForType.isAtEnd {
            let elementForType = try arrayContainerForType.nestedContainer(keyedBy: ElementTypeKey.self)
            let encodingType = try elementForType.decode(String.self, forKey: elementTypeKey)
            try elements.append(decode(encodingType: encodingType, in: &arrayContainer))
        }
        self.elements = elements
    }

    public func encode(to encoder: Encoder) throws {
        var topContainer = encoder.container(keyedBy: ElementsKey.self)
        try topContainer.encode(elements, forKey: elementsKey)
    }

    open var elementsKey: ElementsKey {
        fatalError("Override in subclass.")
    }

    open var elementTypeKey: ElementTypeKey {
        fatalError("Override in subclass.")
    }

    open func decode(encodingType: String, in arrayContainer: inout UnkeyedDecodingContainer) throws -> Element {
        fatalError("Override in subclass.")
    }
}

/// This is an abstract root class. It defines the behavior of encoding and decoding the `type` field.
/// It also defines the `CodingKey` for the aggregate of elements and the type of each element.
/// You can use this class as-is or create a similar class where the "elements" and "type" fields have
/// different names.
open class CodableTypedElement: Codable {
    open class var encodingType: String { fatalError("Override in subclass.") }

    public enum TypeKey: CodingKey {
        case type
    }

    public enum ElementsKey: CodingKey {
        case elements
    }

    public init() {
    }

    public required init(from decoder: Decoder) throws {
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TypeKey.self)
        try container.encode(type(of: self).encodingType, forKey: .type)
    }
}

// Example of usage. Can be pasted into a playground and tested.
//
//    /// This is a protocol for objects with names.
//    protocol Named {
//        var name: String { get }
//    }
//
//    /// This represents a person: a named thing with an optional birthday.
//    class Person: CodableTypedElement, Named, CustomStringConvertible {
//        private typealias `Self` = Person
//        class var encodingType: String { return "person" }
//
//        var name: String
//        var birthday: Date?
//
//        private enum CodingKeys: CodingKey {
//            case name
//            case birthday
//        }
//
//        init(name: String, birthday: Date? = nil) {
//            self.name = name
//            self.birthday = birthday
//            super.init(encodingType: Self.encodingType)
//        }
//
//        required init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            name = try container.decode(String.self, forKey: .name)
//            birthday = try container.decodeIfPresent(Date.self, forKey: .birthday)
//            try super.init(from: decoder)
//        }
//
//        override func encode(to encoder: Encoder) throws {
//            try super.encode(to: encoder)
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(name, forKey: .name)
//            try container.encodeIfPresent(birthday, forKey: .birthday)
//        }
//
//        var description: String {
//            return "Person(encodingType: \(encodingType), name: \(name), birthday: \(String(describing: birthday)))"
//        }
//    }
//
//
//    /// This represents a place: a named thing with a fixed position on Earth.
//    class Place: CodableTypedElement, Named, CustomStringConvertible {
//        private typealias `Self` = Place
//        class var encodingType: String { return "place" }
//
//        var name: String
//        var latitude: Double
//        var longitude: Double
//
//        private enum CodingKeys: CodingKey {
//            case name
//            case latitude
//            case longitude
//        }
//
//        init(name: String, latitude: Double, longitude: Double) {
//            self.name = name
//            self.latitude = latitude
//            self.longitude = longitude
//            super.init(encodingType: Self.encodingType)
//        }
//
//        required init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            name = try container.decode(String.self, forKey: .name)
//            latitude = try container.decode(Double.self, forKey: .latitude)
//            longitude = try container.decode(Double.self, forKey: .longitude)
//            try super.init(from: decoder)
//        }
//
//        override func encode(to encoder: Encoder) throws {
//            try super.encode(to: encoder)
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(name, forKey: .name)
//            try container.encode(latitude, forKey: .latitude)
//            try container.encode(longitude, forKey: .longitude)
//        }
//
//        var description: String {
//            return "Place(encodingType: \(encodingType), name: \(name), latitude: \(latitude), longitude: \(longitude))"
//        }
//    }
//
//    class ExampleContainer: CodableTypedCollection<CodableTypedElement, CodableTypedElement.ElementsKey, CodableTypedElement.TypeKey> {
//        override var elementsKey: CodableTypedElement.ElementsKey {
//            return .elements
//        }
//
//        override var elementTypeKey: CodableTypedElement.TypeKey {
//            return .type
//        }
//
//        override func decode(encodingType: String, in arrayContainer: inout UnkeyedDecodingContainer) throws -> CodableTypedElement {
//            switch encodingType {
//            case Person.encodingType:
//                return try arrayContainer.decode(Person.self)
//            case Place.encodingType:
//                return try arrayContainer.decode(Place.self)
//            default:
//                preconditionFailure()
//            }
//        }
//    }
//
//    let dateFormatter = ISO8601DateFormatter()
//    dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
//    let wolfsBirthday = dateFormatter.date(from: "1965-05-15")!
//    let wolf = Person(name: "Wolf") //, birthday: wolfsBirthday)
//    let losAngeles = Place(name: "Los Angeles", latitude: 34.052235, longitude: -118.243683)
//
//    let thingContainer = ExampleContainer(elements: [wolf, losAngeles])
//
//    thingContainer.elements.forEach { print($0) }
//
//    // Prints:
//    //    Person(encodingType: person, name: Wolf, birthday: Optional(1965-05-15 00:00:00 +0000))
//    //    Place(encodingType: place, name: Los Angeles, latitude: 34.052235, longitude: -118.243683)
//
//    let encodedThingsData: Data
//    do {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        encoder.dateEncodingStrategy = .iso8601
//        encodedThingsData = try encoder.encode(thingContainer)
//        print(String(data: encodedThingsData, encoding: .utf8)!)
//    } catch {
//        fatalError(error.localizedDescription)
//    }
//
//    // Prints:
//    //    {
//    //      "things" : [
//    //        {
//    //          "type" : "person",
//    //          "name" : "Wolf",
//    //          "birthday" : "1965-05-15T00:00:00Z"
//    //        },
//    //        {
//    //          "latitude" : 34.052235000000003,
//    //          "type" : "place",
//    //          "name" : "Los Angeles",
//    //          "longitude" : -118.243683
//    //        }
//    //      ]
//    //    }
//
//    do {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        let decodedThingsContainer = try decoder.decode(ExampleContainer.self, from: encodedThingsData)
//        decodedThingsContainer.elements.forEach { print($0) }
//    } catch {
//        fatalError(error.localizedDescription)
//    }
//
//    // Prints:
//    //    Person(encodingType: person, name: Wolf, birthday: Optional(1965-05-15 00:00:00 +0000))
//    //    Place(encodingType: place, name: Los Angeles, latitude: 34.052235, longitude: -118.243683)
