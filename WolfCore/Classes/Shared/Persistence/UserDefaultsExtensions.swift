//
//  UserDefaultsExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/13/15.
//  Copyright © 2015 WolfMcNally.com.
//

import Foundation
import ExtensibleEnumeratedName
import WolfLog

public let userDefaults = UserDefaults.standard

extension LogGroup {
    public static let userDefaults = LogGroup("userDefaults")
}

public struct UserDefaultsKey: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

extension UserDefaults {
    public subscript<T: Codable>(key: UserDefaultsKey) -> T? {
        get {
            do {
                guard let data = userDefaults.object(forKey: key.rawValue) as? Data else { return nil }
                let value = try PropertyListDecoder().decode(T.self, from: data)
                logTrace("get key: \(key), value: \(value†)", group: .userDefaults)
                return value
            } catch {
                logError(error)
                return nil
            }
        }

        set {
            logTrace("set key: \(key), newValue: \(newValue†)", group: .userDefaults)
            if let newValue = newValue {
                do {
                    let data = try PropertyListEncoder().encode(newValue)
                    userDefaults.set(data, forKey: key.rawValue)
                    userDefaults.synchronize()
                } catch {
                    logError(error)
                }
            } else {
                userDefaults.removeObject(forKey: key.rawValue)
                userDefaults.synchronize()
            }
        }
    }
}
