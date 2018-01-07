//
//  SwiftJSON.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/18/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

//public typealias JSON = SwiftJSON

public struct SwiftJSON {
    public typealias Value = Any
    public typealias Array = [Value]
    public typealias Dictionary = [String: Value]
    public typealias DictionaryOfStrings = [String: String]
    public typealias ArrayOfDictionaries = [Dictionary]
    
    public let value: Value
    public let data: Data
    
    public var string: String {
        return try! data |> UTF8.init |> String.init
    }
    
    public init(value: Value) throws {
        self.value = value
        let writer = Writer()
        try writer.emit(value: value, allowsFragment: false)
        data = writer.string |> Data.init
    }
    
    public init(data: Data) throws {
        self.data = data
        let reader = try Reader(data: data)
        value = try reader.parseValue(allowsFragment: false)
    }
    
    public init(string: String) throws {
        try self.init(data: string |> Data.init)
    }
    
    private static let space: Character = " "
    private static let tab: Character = "\t"
    private static let newline: Character = "\n"
    private static let carriageReturn: Character = "\r"
    
    private static let openBracket: Character = "["
    private static let closeBracket: Character = "]"
    private static let openBrace: Character = "{"
    private static let closeBrace: Character = "}"
    private static let comma: Character = ","
    private static let colon: Character = ":"
    
    private static let quoteMark: Character = "\""
    private static let reverseSolidus: Character = "\\"
    
    private static let literalFalse = "false"
    private static let literalTrue = "true"
    private static let literalNull = "null"
    
    public class Null {
    }
    
    public static let null = Null()
    
    public static func isNull(_ value: Value) -> Bool {
        return value is Null
    }
    
    public enum ReadError: Error {
        case noTopLevelObjectOrArray
        case unexpectedEndOfData
        case unknownValue
        case unterminatedArray
        case keyExpected
        case nameSeparatorExpected
        case unterminatedDictionary
        case unterminatedString
        case unterminatedEscapeSequence
        case unknownEscapeSequence
        case malformedNumber
    }
    
    public final class Reader {
        private let string: String
        private var index: StringIndex
        
        init(data: Data) throws {
            self.string = try data |> UTF8.init |> String.init
            index = string.startIndex
        }
        
        private var hasMore: Bool {
            return index != string.endIndex
        }
        
        private var nextCharacter: Character {
            return string[index]
        }
        
        private func advance() {
            index = string.index(after: index)
        }
        
        private func advance(by offset: Int) {
            index = string.index(index, offsetBy: offset)
        }
        
        private func advance(ifNextCharacterIs character: Character) -> Bool {
            guard hasMore else { return false }
            if character == nextCharacter {
                advance()
                return true
            }
            return false
        }
        
        private func advance(ifNextCharacterIsNot character: Character) -> Bool {
            guard hasMore else { return false }
            if character != nextCharacter {
                advance()
                return true
            }
            return false
        }
        
        private func advance(ifNextCharacterIsIn characters: [Character]) -> Bool {
            guard hasMore else { return false }
            if characters.contains(nextCharacter) {
                advance()
                return true
            }
            return false
        }
        
        private static let whitespace = [SwiftJSON.space, SwiftJSON.tab, SwiftJSON.newline, SwiftJSON.carriageReturn]
        
        private func skipWhitespace() throws {
            repeat { } while advance(ifNextCharacterIsIn: Reader.whitespace)
            guard hasMore else { throw ReadError.unexpectedEndOfData }
        }
        
        func parseValue(allowsFragment: Bool = true) throws -> SwiftJSON.Value {
            try skipWhitespace()
            if let array = try parseArray() {
                return array
            }
            
            if let dictionary = try parseDictionary() {
                return dictionary
            }
            
            guard allowsFragment else { throw ReadError.noTopLevelObjectOrArray }
            
            if let string = try parseString() {
                return string
            }
            
            if let number = try parseNumber() {
                return number
            }
            
            if let bool = try parseBool() {
                return bool
            }
            
            if try parseNull() {
                return SwiftJSON.null
            }
            
            throw ReadError.unknownValue
        }
        
        private func parseArray() throws -> SwiftJSON.Array? {
            guard advance(ifNextCharacterIs: SwiftJSON.openBracket) else { return nil }
            var array = SwiftJSON.Array()
            repeat {
                try skipWhitespace()
                guard !advance(ifNextCharacterIs: SwiftJSON.closeBracket) else { return array }
                try skipWhitespace()
                let value = try parseValue()
                array.append(value)
                try skipWhitespace()
            } while advance(ifNextCharacterIs: SwiftJSON.comma)
            return array
        }
        
        private func parseDictionary() throws -> SwiftJSON.Dictionary? {
            guard advance(ifNextCharacterIs: SwiftJSON.openBrace) else { return nil }
            var dictionary = SwiftJSON.Dictionary()
            repeat {
                try skipWhitespace()
                guard !advance(ifNextCharacterIs: SwiftJSON.closeBrace) else { return dictionary }
                guard let key = try parseString() else { throw ReadError.keyExpected }
                try skipWhitespace()
                guard advance(ifNextCharacterIs: SwiftJSON.colon) else { throw ReadError.nameSeparatorExpected }
                try skipWhitespace()
                let value = try parseValue()
                dictionary[key] = value
                try skipWhitespace()
            } while advance(ifNextCharacterIs: SwiftJSON.comma)
            try skipWhitespace()
            return dictionary
        }
        
        private func parseString() throws -> String? {
            guard advance(ifNextCharacterIs: SwiftJSON.quoteMark) else { return nil }
            var string = ""
            repeat {
                guard hasMore else { throw ReadError.unterminatedString }
                let character = nextCharacter
                advance()
                switch character {
                case SwiftJSON.quoteMark:
                    return string
                case SwiftJSON.reverseSolidus:
                    string.append(try parseEscapeSequence())
                default:
                    string.append(character)
                }
            } while true
        }
        
        private func parseEscapeSequence() throws -> Character {
            guard hasMore else { throw ReadError.unterminatedEscapeSequence }
            let character = nextCharacter
            advance()
            switch character {
            case SwiftJSON.quoteMark:
                return SwiftJSON.quoteMark
            case SwiftJSON.reverseSolidus:
                return SwiftJSON.reverseSolidus
            case "t":
                return SwiftJSON.tab
            case "n":
                return SwiftJSON.newline
            case "r":
                return SwiftJSON.carriageReturn
            default:
                throw ReadError.unknownEscapeSequence
            }
        }
        
        private static let numberPrefixRegex = try! ~/"^[0-9-]"
        private static let numberRegex = try! ~/"^-?(0|([1-9][0-9]*))(\\.[0-9]+)?(e[+-][0-9]+)?"
        
        private func parseNumber() throws -> Double? {
            let substring = string.substring(from: index)
            guard Reader.numberPrefixRegex ~? substring else { return nil }
            let matches = Reader.numberRegex ~?? substring
            guard let firstMatch = matches.first else { throw ReadError.malformedNumber }
            let (_, numberStr) = firstMatch.get(atIndex: 0, inString: substring)
            advance(by: numberStr.characters.count)
            guard let value = Double(numberStr) else { throw ReadError.malformedNumber }
            return value
        }
        
        private func parseBool() throws -> Bool? {
            let s = string.substring(from: index)
            if s.hasPrefix(SwiftJSON.literalTrue) {
                advance(by: SwiftJSON.literalTrue.characters.count)
                return true
            } else if s.hasPrefix(SwiftJSON.literalFalse) {
                advance(by: SwiftJSON.literalFalse.characters.count)
                return false
            }
            return nil
        }
        
        private func parseNull() throws -> Bool {
            let s = string.substring(from: index)
            if s.hasPrefix(SwiftJSON.literalNull) {
                advance(by: SwiftJSON.literalNull.characters.count)
                return true
            }
            return false
        }
    }
    
    public enum WriteError: Error {
        case noTopLevelObjectOrArray
        case unknownValue
    }
    
    public final class Writer {
        var string = ""
        
        func emit(_ character: Character) {
            string.append(character)
        }
        
        func emit(_ string: String) {
            self.string.append(string)
        }
        
        func emit(string: String) {
            emit("\"\(string)\"")
        }
        
        func emit(number: Double) {
            let n = String(value: number, precision: 17)
            emit(n)
        }
        
        func emit(bool: Bool) {
            emit(bool ? SwiftJSON.literalTrue : SwiftJSON.literalFalse)
        }
        
        func emit(dictionary: Dictionary) throws {
            emit(SwiftJSON.openBrace)
            var first = true
            for (key, value) in dictionary {
                if first {
                    first = false
                } else {
                    emit(SwiftJSON.comma)
                }
                emit(string: key)
                emit(SwiftJSON.colon)
                try emit(value: value, allowsFragment: true)
            }
            emit(SwiftJSON.closeBrace)
        }
        
        func emit(array: Array) throws {
            emit(SwiftJSON.openBracket)
            var first = true
            for value in array {
                if first {
                    first = false
                } else {
                    emit(SwiftJSON.comma)
                }
                try emit(value: value, allowsFragment: true)
            }
            emit(SwiftJSON.closeBracket)
        }
        
        func emit(value: Value, allowsFragment: Bool) throws {
            //            guard let value = value else {
            //                if allowsFragment {
            //                    emit(SwiftJSON.literalNull)
            //                    return
            //                } else {
            //                    throw WriteError.unknownValue
            //                }
            //            }
            
            switch value {
            case let dictionary as Dictionary:
                try emit(dictionary: dictionary)
                return
            case let array as Array:
                try emit(array: array)
                return
            default:
                break
            }
            
            guard allowsFragment else {
                throw WriteError.noTopLevelObjectOrArray
            }
            
            switch value {
            case let string as String:
                emit(string: string)
            case let number as Double:
                emit(number: number)
            case let bool as Bool:
                emit(bool: bool)
            case is SwiftJSON.Null:
                emit(SwiftJSON.literalNull)
            default:
                throw WriteError.unknownValue
            }
        }
    }
}

public func swiftJSONTest() {
    do {
        let raw = "{\"color\": \"red\", \"age\": 51, \"dict\": {\"a\": 50.5, \"b\": -3.1415927}, \"awesome\": true, \"array\": [1, 2, false, null]}"
        print(raw)
        let j1 = try raw |> SwiftJSON.init
        print(j1.value)
        let j2 = try j1 |> SwiftJSON.init
        print(j2.string)
    } catch let error {
        print(error)
    }
}
