//
//  BSON.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/4/16.
//  Copyright © 2016 WolfMcNally.com.
//

//
// http://bsonspec.org/spec.html
//

import Foundation
import WolfPipe
import WolfFoundation

public struct BSON {
    public typealias Value = Any?
    public typealias Dictionary = [String: Value]
    public typealias Array = [Value]

    public static func encode(_ dict: Dictionary) throws -> Data {
        return try dict |> BSON.doc |> BSON.data
    }

    public static func decode(_ data: Data) throws -> Dictionary {
        return try data |> BSON.doc |> BSON.bson
    }
}

extension BSON {
    static func doc(dict: Dictionary) throws -> BSONDocument {
        return try BSONDocument(dict: dict)
    }

    static func doc(data: Data) -> BSONDocument {
        return BSONDocument(data: data)
    }

    static func data(doc: BSONDocument) -> Data {
        return doc.data
    }

    static func bson(doc: BSONDocument) throws -> Dictionary {
        return try doc.decode()
    }
}

public struct BSONError: Error {
    public let message: String
    public let code: Int

    public init(message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }

    public var identifier: String {
        return "BSONError(\(code))"
    }
}

extension BSONError: CustomStringConvertible {
    public var description: String {
        return "BSONError(\(message))"
    }
}


public func testBSON() {
    do {
        var greetingsDict = BSON.Dictionary()
        greetingsDict["hello"] = "world"
        greetingsDict.updateValue(nil, forKey: "goodbye")
        testBSON(greetingsDict)
    }

    do {
        var greetingsDict = BSON.Dictionary()
        greetingsDict["hello"] = "world"
        greetingsDict.updateValue(nil, forKey: "goodbye")

        var personDict = BSON.Dictionary()
        personDict["firstName"] = "Robert"
        personDict["lastName"] = "McNally"
        personDict["greetings"] = greetingsDict

        var array = BSON.Array()
        array.append("awesome")
        array.append(nil)
        array.append(5.05)
        array.append(personDict)
        array.append(Int32(1986))
        var dict = BSON.Dictionary()
        dict["BSON"] = array
        testBSON(dict)
    }
}

private func testBSON(_ encodeDict: BSON.Dictionary) {
    do {
        print("encodeDict: \(encodeDict)")
        print(bsonDict: encodeDict)
        let bson = try BSONDocument(dict: encodeDict)
        print("bson: \(bson)")
        let decodeDict = try bson.decode()
        print("decodeDict:")
        print(bsonDict: decodeDict)
        let bson2 = try BSONDocument(dict: decodeDict)
        print("bson2: \(bson2)")
    } catch let error {
        print("error: \(error)")
    }
}


enum BSONBinarySubtype: UInt8 {
    case generic = 0x00
    case function = 0x01
    case uuid = 0x04
    case md5 = 0x05
    case userDefined = 0x80
}

enum BSONElementType: UInt8 {
    case endOfObject = 0x00
    case double = 0x01
    case string = 0x02
    case document = 0x03
    case array = 0x04
    case binary = 0x05
    case objectID = 0x07
    case boolean = 0x08
    case dateTime = 0x09
    case null = 0x0a
    case regex = 0x0b
    case javaScript = 0x0d
    case javaScriptWithScope = 0x0f
    case int32 = 0x10
    case timestamp = 0x11
    case int = 0x12
    case minKey = 0xff
    case maxKey = 0x7f
}

public class BSONBuffer {
    internal(set) var data: Data
    var mark = 0

    init() {
        data = Data()
    }

    init(data: Data, mark: Int = 0) {
        self.data = data
        self.mark = 0
    }
}

extension BSONBuffer {
    func append(byte: UInt8) {
        data.append([byte], count: 1)
    }

    func append(data inData: Data) {
        data.append(inData)
    }

    func append(bytes p: UnsafePointer<UInt8>, count: Int) {
        data.append(p, count: count)
    }

    func append(bytes: ContiguousArray<UInt8>) {
        bytes.withUnsafeBufferPointer { ptr in
            data.append(ptr.baseAddress!, count: bytes.count)
        }
    }

    func append(bytes: ContiguousArray<CChar>) {
        bytes.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: bytes.count) {
                data.append($0, count: bytes.count)
            }
        }
    }

    func append(int32: Int32) {
        var i = int32.littleEndian
        withUnsafePointer(to: &i) {
            let count = MemoryLayout<Int32>.size
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                append(bytes: $0, count: count)
            }
        }
    }

    func append(int: Int) {
        var i = int.littleEndian
        withUnsafePointer(to: &i) {
            let count = MemoryLayout<Int>.size
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                append(bytes: $0, count: count)
            }
        }
    }

    func append(double: Double) {
        var d = double
        withUnsafePointer(to: &d) {
            let count = MemoryLayout<Double>.size
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                append(bytes: $0, count: count)
            }
        }
    }

    func append(cString: String) {
        append(bytes: cString.utf8CString)
    }

    func append(string: String) {
        let utf8 = string.utf8CString
        append(int32: Int32(utf8.count))
        append(bytes: utf8)
    }

    func append(buffer: BSONBuffer) {
        data.append(buffer.data)
    }

    func append(document: BSONDocument) {
        append(int32: Int32(document.elementList.data.count + MemoryLayout<Int32>.size + 1))
        append(buffer: document.elementList)
        append(byte: 0x00)
    }
}

extension BSONBuffer {
    func readBytes(_ count: Int) throws -> UnsafePointer<UInt8> {
        let available = data.count - mark
        guard available >= count else {
            throw BSONError(message: "Needed \(count) bytes, but only \(available) available.")
        }
        let p: UnsafePointer<UInt8> = data.withUnsafeBytes { $0 + mark }
        mark += count
        return p
    }

    func readData(_ count: Int) throws -> Data {
        let p = try readBytes(count)
        return Data(bytes: p, count: count)
    }

    func readByte() throws -> UInt8 {
        let p = try readBytes(1)
        return p[0]
    }

    func readUntilNul() throws -> Data {
        var bytes = Data()
        while true {
            let byte = try readByte()
            bytes.append([byte], count: 1)
            if byte == 0x00 {
                break
            }
        }
        return bytes
    }

    func readInt32() throws -> Int32 {
        return try readBytes(MemoryLayout<Int32>.size).withMemoryRebound(to: Int32.self, capacity: 1) {
            return Int32(littleEndian: $0[0])
        }
    }

    func readInt() throws -> Int {
        return try readBytes(MemoryLayout<Int>.size).withMemoryRebound(to: Int.self, capacity: 1) {
            return Int(littleEndian: $0[0])
        }
    }

    func readDouble() throws -> Double {
        return try readBytes(MemoryLayout<Double>.size).withMemoryRebound(to: Double.self, capacity: 1) {
            return $0[0]
        }
    }

    func readBoolean() throws -> Bool {
        let b = try readByte()
        switch b {
        case 0x00:
            return false
        case 0x01:
            return true
        default:
            throw BSONError(message: "Expected Boolean value 0 or 1, got: \(b)")
        }
    }

    private func decodeString(from data: Data) throws -> String {
        return try data.withUnsafeBytes { (ptr: UnsafePointer<CChar>) throws -> String in
            let s = String(validatingUTF8: ptr)
            if let s = s {
                return s
            } else {
                throw BSONError(message: "Could not decode UTF-8 string.")
            }
        }
    }

    func readCString() throws -> String {
        let data = try readUntilNul()
        return try decodeString(from: data)
    }

    func readElementName() throws -> String {
        return try readCString()
    }

    func readString() throws -> String {
        let count = Int(try readInt32())
        let p = try readData(count)
        return try decodeString(from: p)
    }

    func readBinary() throws -> Any {
        let count = Int(try readInt32())
        let rawSubtype = try readByte()
        let bytes = try readBytes(count)
        if let subtype = BSONBinarySubtype(rawValue: rawSubtype) {
            switch subtype {
            case .userDefined:
                return bytes
            default:
                throw BSONError(message: "Unsupported binary subtype: \(subtype).")
            }
        } else {
            throw BSONError(message: "Unknown binary subtype: \(rawSubtype).")
        }
    }

    func readElement() throws -> (name: String, value: BSON.Value)? {
        let rawElementType = try readByte()
        guard let elementType = BSONElementType(rawValue: rawElementType) else {
            throw BSONError(message: "Unknown element type: \(rawElementType).")
        }
        guard elementType != .endOfObject else {
            return nil
        }
        let name = try readElementName()
        let value: BSON.Value
        switch elementType {
        case .int:
            value = try readInt()
        case .int32:
            value = try readInt32()
        case .boolean:
            value = try readBoolean()
        case .string:
            value = try readString()
        case .binary:
            value = try readBinary()
        case .double:
            value = try readDouble()
        case .document:
            _ = try readInt32() // throw away size of embedded document
            value = try readDocument()
        case .array:
            _ = try readInt32() // throw away size of embedded array
            value = try readArray()
        case .null:
            value = nil
        default:
            throw BSONError(message: "Unsupported element type: \(elementType).")
        }
        return (name, value)
    }

    func readDocument() throws -> BSON.Dictionary {
        var dict = BSON.Dictionary()
        while true {
            if let result = try readElement() {
                let name = result.name
                let value = result.value
                dict[name] = value
            } else {
                break
            }
        }
        return dict
    }

    func readArray() throws -> BSON.Array {
        var array = BSON.Array()
        while true {
            if let result = try readElement() {
                array.append(result.value)
            } else {
                break
            }
        }
        return array
    }
}

public class BSONDocument: BSONBuffer {
    let elementList = BSONElementList()

    public init(dict: BSON.Dictionary) throws {
        super.init()

        for (name, value) in dict {
            try elementList.appendElement(withName: name, value: value)
        }
        append(document: self)
    }

    public init(array: BSON.Array) throws {
        super.init()

        for (index, value) in array.enumerated() {
            try elementList.appendElement(withName: String(index), value: value)
        }
        append(document: self)
    }

    public init(data: Data) {
        super.init()

        self.data = data
    }
}

extension BSONDocument {
    public func decode() throws -> BSON.Dictionary {
        mark = 0
        let size = Int(try readInt32())
        if size != data.count {
            throw BSONError(message: "Expected buffer of size: \(size), got: \(data.count)")
        }
        return try readDocument()
    }
}

extension BSONDocument: CustomStringConvertible {
    public var description: String {
        let s = data |> toHex
        return "<BSONDocument \(s))>"
    }
}

class BSONElementList: BSONBuffer {
    func appendElement(withName name: String, value: Any?) throws {
        if let value = value {
            switch value {
            case let int as Int:
                append(int: int, withName: name)
            case let int32 as Int32:
                append(int32: int32, withName: name)
            case let bool as Bool:
                append(boolean: bool, withName: name)
            case let string as String:
                append(string: string, withName: name)
            case let data as Data:
                append(binary: data, withName: name)
            case let double as Double:
                append(double: double, withName: name)
            case let dict as BSON.Dictionary:
                try append(dictionary: dict, withName: name)
            case let array as BSON.Array:
                try append(array: array, withName: name)
            default:
                throw BSONError(message: "Could not encode value \(value).")
            }
        } else {
            appendNull(withName: name)
        }
    }

    //
    // MARK: - Primitives
    //

    private func append(elementName name: String) {
        append(cString: name)
    }

    private func append(binarySubtype subtype: BSONBinarySubtype) {
        append(byte: subtype.rawValue)
    }

    private func append(elementType type: BSONElementType) {
        append(byte: type.rawValue)
    }

    //
    // MARK: - Elements
    //

    private func append(double: Double, withName name: String) {
        append(elementType: .double)
        append(elementName: name)
        append(double: double)
    }

    private func append(string: String, withName name: String) {
        append(elementType: .string)
        append(elementName: name)
        append(string: string)
    }

    private func append(binary data: Data, withName name: String, subtype: BSONBinarySubtype = .userDefined) {
        append(elementType: .binary)
        append(elementName: name)
        append(int32: Int32(data.count))
        append(binarySubtype: subtype)
        append(data: data)
    }

    private func append(boolean: Bool, withName name: String) {
        append(elementType: .boolean)
        append(elementName: name)
        append(byte: boolean ? 0x01 : 0x00)
    }

    private func append(utcDateTime datetime: Int, withName name: String) {
        append(elementType: .dateTime)
        append(elementName: name)
        append(int: datetime)
    }

    private func appendNull(withName name: String) {
        append(elementType: .null)
        append(elementName: name)
    }

    private func append(regex pattern: String, options: String, withName name: String) {
        append(elementType: .regex)
        append(elementName: name)
        append(cString: pattern)
        append(cString: options)
    }

    private func append(javaScript: String, withName name: String) {
        append(elementType: .javaScript)
        append(elementName: name)
        append(string: javaScript)
    }

    private func append(int32 int: Int32, withName name: String) {
        append(elementType: .int32)
        append(elementName: name)
        append(int32: int)
    }

    private func append(int: Int, withName name: String) {
        append(elementType: .int)
        append(elementName: name)
        append(int: int)
    }

    private func append(dictionary dict: BSON.Dictionary, withName name: String) throws {
        let document = try BSONDocument(dict: dict)
        append(elementType: .document)
        append(elementName: name)
        append(document: document)
    }

    private func append(array: BSON.Array, withName name: String) throws {
        let arr = try BSONDocument(array: array)
        append(elementType: .array)
        append(elementName: name)
        append(document: arr)
    }
}

public func print(bsonDict dict: BSON.Dictionary, indent: String = "", level: Int = 0) {
    for name in dict.keys {
        printBSONElement(withName: name, value: dict[name]!, indent: indent, level: level)
    }
}

private func print(bsonArray array: BSON.Array, indent: String = "", level: Int = 0) {
    for (index, value) in array.enumerated() {
        printBSONElement(withName: String(index), value: value, indent: indent, level: level)
    }
}

private func printBSONElement(withName name: String, value: BSON.Value, indent: String, level: Int) {
    let type: String
    let valueStr: String
    let pfx = "✅  "
    let err = "🚫  "
    if let value = value {
        switch value {
        case let int as Int:
            type = "\(pfx) Int"
            valueStr = "\(int)"
        case let int as Int32:
            type = "\(pfx) Int32"
            valueStr = "\(int)"
        case let s as String:
            type = "\(pfx) String"
            valueStr = "\"\(s)\""
        case let d as Double:
            type = "\(pfx) Double"
            valueStr = "\(d)"
        case is BSON.Dictionary:
            type = "\(pfx) Document"
            valueStr = ""
        case is BSON.Array:
            type = "\(pfx) Array"
            valueStr = ""
        case let b as Bool:
            type = "\(pfx) Boolean"
            valueStr = "\(b)"
        case let b as Data:
            type = "\(pfx) Data"
            valueStr = b |> toHex
        default:
            type = "\(err) UNKNOWN"
            valueStr = "\(value)"
        }
    } else {
        type = "nil"
        valueStr = ""
    }
    print("\(indent)\(name): \(type) \(valueStr)")
    if let value = value {
        let nextLevel = level + 1
        let nextIndent = String.tab + indent
        switch value {
        case let dict as BSON.Dictionary:
            print(bsonDict: dict, indent: nextIndent, level: nextLevel)
        case let array as BSON.Array:
            print(bsonArray: array, indent: nextIndent, level: nextLevel)
        default:
            break
        }
    }
}

// swiftlint:enable cyclomatic_complexity
