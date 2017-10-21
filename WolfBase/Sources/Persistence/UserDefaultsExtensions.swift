//
//  UserDefaultsExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 7/13/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

public let userDefaults = UserDefaults.standard

extension LogGroup {
  public static let userDefaults = LogGroup("userDefaults")
}

//extension UserDefaults {
//  public subscript(key: String) -> Any? {
//    get {
//      let value = userDefaults.object(forKey: key)
//      logTrace("get key: \(key), value: \(value†)", group: .userDefaults)
//      return value as AnyObject?
//    }
//    set {
//      logTrace("set key: \(key), newValue: \(newValue†)", group: .userDefaults)
//      if let newValue = newValue {
//        userDefaults.set(newValue, forKey: key)
//      } else {
//        userDefaults.removeObject(forKey: key)
//      }
//      userDefaults.synchronize()
//    }
//  }
//}

// Based on "Type-Safe User Defaults" by Mike Ash
//
//  https://www.mikeash.com/pyblog/friday-qa-2017-10-06-type-safe-user-defaults.html
//  https://github.com/mikeash/TSUD

public protocol UserDefault {
    associatedtype ValueType: Codable
    
    init()
    
    static var defaultValue: ValueType { get }
    
    static var stringKey: String { get }
}

public extension UserDefault {
    static var stringKey: String {
        let s = String(describing: Self.self)
        if let index = s.index(of: " ") {
            return String(s[..<index])
        } else {
            return s
        }
    }
}

extension UserDefault {
    public static var value: ValueType {
        get {
            return get()
        }
        set {
            set(newValue)
        }
    }
    
    public static func get(_ nsud: UserDefaults = .standard) -> ValueType {
        return self.init()[nsud]
    }
    
    public static func set(_ value: ValueType, _ nsud: UserDefaults = .standard) {
        self.init()[nsud] = value
    }
    
    public subscript(nsud: UserDefaults) -> ValueType {
        get {
            return decode(nsud.object(forKey: Self.stringKey)) ?? Self.defaultValue
        }
        nonmutating set {
            nsud.set(encode(newValue), forKey: Self.stringKey)
            nsud.synchronize()
        }
    }
    
    private func decode(_ plist: Any?) -> ValueType? {
        guard let plist = plist else { return nil }
        
        switch ValueType.self {
        case is Date.Type,
             is Data.Type:
            return plist as? ValueType
            
        default:
            let data = try? PropertyListSerialization.data(fromPropertyList: plist, format: .binary, options: 0)
            guard let dataUnwrapped = data else { return nil }
            return try? PropertyListDecoder().decode(ValueType.self, from: dataUnwrapped)
        }
    }
    
    private func encode(_ value: ValueType) -> Any? {
        switch value {
        case let value as OptionalProtocol where value.isNone: return nil
        case is Date: return value
        case is Data: return value
            
        default:
            let data = try? PropertyListEncoder().encode([value])
            guard let dataUnwrapped = data else { return nil }
            let wrappedPlist = (try? PropertyListSerialization.propertyList(from: dataUnwrapped, options: [], format: nil)) as? [Any]
            return wrappedPlist?[0]
        }
    }
}
