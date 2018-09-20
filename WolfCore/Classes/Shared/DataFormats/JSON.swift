//
//  JSON.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation
import WolfPipe
import WolfStrings
import WolfLog
import WolfConcurrency

public typealias JSON = FoundationJSON

public typealias JSONPromise = Promise<JSON>

public class Cached<T> {
    var value: T?
}

public struct FoundationJSON {
    private typealias `Self` = FoundationJSON

    public typealias Value = Any
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]
    public typealias DictionaryOfStrings = [String: String]
    public typealias ArrayOfStrings = [String]
    public typealias ArrayOfDictionaries = [Dictionary]
    public typealias Null = NSNull

    public static let null = Null()

    private var _value = Cached<Value>()
    private var _data = Cached<Data>()

    public private(set) var value: Value {
        get {
            if _value.value == nil {
                _value.value = try! JSONSerialization.jsonObject(with: _data.value!)
            }
            return _value.value!
        }

        set {
            _value.value = newValue
            _data.value = nil
        }
    }

    public private(set) var data: Data {
        get {
            if _data.value == nil {
                _data.value = try! JSONSerialization.data(withJSONObject: _value.value!)
            }
            return _data.value!
        }

        set {
            _data.value = newValue
            _value.value = nil
        }
    }

    public var string: String {
        return try! data |> fromUTF8
    }

    public var prettyString: String {
        let outputStream = OutputStream(toMemory: ())
        outputStream.open()
        defer { outputStream.close() }
        #if os(Linux)
            _ = try! JSONSerialization.writeJSONObject(value, toStream: outputStream, options: [.prettyPrinted])
        #else
            JSONSerialization.writeJSONObject(value, to: outputStream, options: [.prettyPrinted], error: nil)
        #endif
        let data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        return String(data: data, encoding: .utf8)!
    }

    public var dictionary: Dictionary {
        return value as! Dictionary
    }

    public var array: Array {
        return value as! Array
    }

    public var dictionaryOfStrings: DictionaryOfStrings {
        return value as! DictionaryOfStrings
    }

    public var arrayOfDictionaries: ArrayOfDictionaries {
        return value as! ArrayOfDictionaries
    }

    public init(data: Data) throws {
        do {
            _value.value = try JSONSerialization.jsonObject(with: data)
            _data.value = data
        } catch let error {
            throw error
        }
    }

    public init(value: Value) throws {
        do {
            _data.value = try JSONSerialization.data(withJSONObject: value)
            _value.value = value
        } catch let error {
            logError(error)
            throw error
        }
    }

    private init(fragment: Value) {
        _value.value = fragment
    }

    public init(_ n: Int) {
        self.init(fragment: n)
    }

    public init(_ d: Double) {
        self.init(fragment: d)
    }

    public init(_ f: Float) {
        self.init(fragment: f)
    }

    public init(_ s: String) {
        self.init(fragment: s)
    }

    public init(_ b: Bool) {
        self.init(fragment: b)
    }

    public init(_ n: Null) {
        self.init(fragment: n)
    }

    //
    // This constructor includes a label for the first argument to prevent confusion between:
    //
    // let json = JSON(["email": email])
    //
    // and:
    //
    // let json = JSON(["email", email]) // illegal
    //
    // The second case must be stated like this:
    //
    // let json = JSON(array: ["email", email])
    //

    public init(array inArray: [Any?]) {
        var outArray = [Value]()
        for inValue in inArray {
            if let inValue = inValue {
                if let v = inValue as? JSONRepresentable {
                    outArray.append(v.json.value)
                } else if let a = inValue as? [Any?] {
                    let j = JSON(array: a)
                    outArray.append(j.value)
                } else if let d = inValue as? [AnyHashable: Any?] {
                    let j = JSON(d)
                    outArray.append(j.value)
                } else {
                    fatalError("Not a JSON value.")
                }
            } else {
                outArray.append(Self.null)
            }
        }
        try! self.init(value: outArray)
    }

    public init(_ inDict: [AnyHashable: Any?]) {
        var outDict = [String: Value]()
        for (name, inValue) in inDict {
            let name = "\(name)"
            if let inValue = inValue {
                if let v = inValue as? JSONRepresentable {
                    outDict[name] = v.json.value
                } else if let a = inValue as? [Any?] {
                    let j = JSON(array: a)
                    outDict[name] = j.value
                } else if let d = inValue as? [AnyHashable: Any?] {
                    let j = JSON(d)
                    outDict[name] = j.value
                } else {
                    fatalError("Not a JSON value.")
                }
            }
        }
        try! self.init(value: outDict)
    }

    public init(string: String) throws {
        try self.init(data: string |> toUTF8)
    }

    public static func isNull(_ value: Value) -> Bool {
        return value is Null
    }

    public mutating func setValue(_ value: JSONRepresentable, for key: String) {
        var d = dictionary
        d[key] = value.json.value
        _value.value = d
        _data.value = nil
    }

    public mutating func setValue(_ value: JSONRepresentable, for index: Int) {
        var a = array
        a[index] = value.json.value
        _value.value = a
        _data.value = nil
    }

    public mutating func setValue(_ value: JSONRepresentable?, for key: String) {
        if let value = value {
            setValue(value, for: key)
        } else {
            setValue(Self.null, for: key)
        }
    }

    public mutating func setValue(_ value: JSONRepresentable?, for index: Int) {
        if let value = value {
            setValue(value, for: index)
        } else {
            setValue(Self.null, for: index)
        }
    }
}

extension FoundationJSON: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}
