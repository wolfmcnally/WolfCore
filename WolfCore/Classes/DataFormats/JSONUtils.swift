//
//  JSONUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension JSON {
    public enum Error: Swift.Error {
        case missingKey(String)
        case wrongType(String, Any)
        case notAnArray(String, Any)
        case notAnArrayOfStrings(String, Array)
    }
}

extension JSON {
    /// Get a value of type `T` for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the type of the value cannot be cast to the generic type `T`.
    public func getGenericValue<T>(for key: String) throws -> T? {
        guard let value = dictionary[key] else { return nil }
        if let v = value as? T {
            return v
        } else if JSON.isNull(value) {
            return nil
        } else {
            throw Error.wrongType(key, value)
        }
    }
    
    public func getValue<T>(for key: String) throws -> T? {
        return try getGenericValue(for: key)
    }
    
    /// Get a value of RawRepresentable type `T` for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be used as a valid `rawValue` of the type `T`.
    public func getValue<T: RawRepresentable>(for key: String) throws -> T? where T.RawValue == String {
        guard let s: String = try getGenericValue(for: key) else { return nil }
        guard let v = T(rawValue: s) else { throw Error.wrongType(key, s) }
        return v
    }
    
    public func getValue(for key: String) throws -> JSON? {
        guard let v: JSON.Value = try getGenericValue(for: key) else { return nil }
        return try JSON(value: v)
    }
    
    /// Get a value of JSONModel type `T` for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be used as a valid JSON.Dictionary.
    public func getValue<T: JSONModel>(for key: String) throws -> T? {
        guard let v: JSON = try getGenericValue(for: key) else { return nil }
        return T(json: v)
    }
    
    /// Get a `URL` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a `URL`.
    public func getValue(for key: String) throws -> URL? {
        guard let s: String = try getGenericValue(for: key) else { return nil }
        guard let url = URL(string: s) else { throw Error.wrongType(key, s) }
        return url
    }
    
    /// Get a `Date` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a `Date`.
    public func getValue(for key: String) throws -> Date? {
        guard let s: String = try getGenericValue(for: key) else { return nil }
        return try Date(iso8601: s)
    }
    
    /// Get a `Color` value for a given key in the JSON dictionary. The value is nullable,
    /// and the return value will be `nil` if either the key does not exist or the value is `null`.
    /// An error will be thrown if the value exists but cannot be parsed into a color.
    public func getValue(for key: String) throws -> Color? {
        guard let s: String = try getGenericValue(for: key) else { return nil }
        return try Color(string: s)
    }
}

extension JSON {
    public func genericValue<T, U>(for key: String, with fallback: T?, f: (U) throws -> T) throws -> T {
        if let v = try getGenericValue(for: key) as U? {
            return try f(v)
        } else if let fallback = fallback {
            return fallback
        } else {
            throw Error.missingKey(key)
        }
    }
    
    /// Get a value of type `T` for a given key in the JSON dictionary. If the `fallback` argument is provided,
    /// it will be substituted only if the key is `null` or nonexistent. An error will be thrown
    /// if the value exists but cannot be cast to the generic type `T`.
    public func getValue<T>(for key: String, with fallback: T? = nil) throws -> T {
        return try genericValue(for: key, with: fallback) { return $0 }
    }
    
    /// Get a value of the RawRepresentable type `T` for a given key in the JSON dictionary. If
    /// the `fallback` argument is provided, it will be substituted only if the key is `null` or nonexistent.
    /// An error will be thrown if the value exists but cannot be used as a valid `rawValue` of `T`.
    public func getValue<T: RawRepresentable>(for key: String, with fallback: T? = nil) throws -> T where T.RawValue == String {
        return try genericValue(for: key, with: fallback) { (s: T.RawValue) throws -> T in
            guard let v = T(rawValue: s) else { throw Error.wrongType(key, s) }
            return v
        }
    }
    
    public func getValue(for key: String, with fallback: JSON? = nil) throws -> JSON {
        return try genericValue(for: key, with: fallback) { (v: JSON.Value) throws -> JSON in
            return try JSON(value: v)
        }
    }
    
    /// Get a value of the JSONModel type `T` for a given key in the JSON dictionary. If
    /// the `fallback` argument is provided, it will be substituted only if the key is `null` or nonexistent.
    /// An error will be thrown if the value exists but cannot be used as a valid JSON.Dictionary
    public func getValue<T: JSONModel>(for key: String, with fallback: T? = nil) throws -> T {
        return try genericValue(for: key, with: fallback) { (v: JSON.Value) throws -> T in
            return try T(json: JSON(value: v))
        }
    }
    
    /// Get a `URL` value for a given key in the JSON dictionary. The URL will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `URL`.
    public func getValue(for key: String, with fallback: URL? = nil) throws -> URL {
        return try genericValue(for: key, with: fallback) { (s: String) throws -> URL in
            guard let url = URL(string: s) else { throw Error.wrongType(key, s) }
            return url
        }
    }
    
    /// Get a `Date` value for a given key in the JSON dictionary. The URL will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `Date`.
    public func getValue(for key: String, with fallback: Date? = nil) throws -> Date {
        return try genericValue(for: key, with: fallback) {
            return try Date(iso8601: $0)
        }
    }
    
    /// Get a `Color` value for a given key in the JSON dictionary. The color will be parsed from a string value in
    /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
    /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `OSColor`.
    public func getValue(for key: String, with fallback: Color? = nil) throws -> Color {
        return try genericValue(for: key, with: fallback) {
            return try Color(string: $0)
        }
    }
}

