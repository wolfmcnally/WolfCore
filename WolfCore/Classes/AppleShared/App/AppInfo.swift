//
//  AppInfo.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/21/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation

public let appInfo = AppInfo(bundle: Bundle.main)

private let kCFBundleShortVersionString = "CFBundleShortVersionString"

public class AppInfo {
    private let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    public func object<T: AnyObject>(forKey key: String) -> T? {
        return bundle.object(forInfoDictionaryKey: key) as? T
    }

    public subscript(key: String) -> AnyObject? {
        return object(forKey: key)
    }

    public subscript(key: CFString) -> AnyObject? {
        return object(forKey: key as String)
    }

    public func hasKey(key: String) -> Bool {
        return self[key] != nil
    }

    public var appName: String {
        return self[kCFBundleNameKey] as! String
    }

    public var bundleIdentifier: String {
        return self[kCFBundleIdentifierKey] as! String
    }

    public var version: String {
        return self[kCFBundleShortVersionString] as! String
    }

    public var build: String {
        return self[kCFBundleVersionKey] as! String
    }
}

extension Bundle {
    public var appInfo: AppInfo {
        return AppInfo(bundle: self)
    }
}
