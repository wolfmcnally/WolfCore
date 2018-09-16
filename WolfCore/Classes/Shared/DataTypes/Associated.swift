//
//  Associated.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/26/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation

public final class Associated<T>: NSObject, NSCopying {
    public typealias ValueType = T
    public let value: ValueType

    public init(_ value: ValueType) { self.value = value }

    public func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(value)
    }
}

extension Associated where T: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(value.copy(with: zone) as! ValueType)
    }
}

extension NSObject {
    public func setAssociatedValue<T>(_ value: T?, for key: UnsafeRawPointer) {
        let v = value.map { Associated<T>($0) }
        objc_setAssociatedObject(self, key, v, .OBJC_ASSOCIATION_COPY)
    }

    public func getAssociatedValue<T>(for key: UnsafeRawPointer) -> T? {
        return (objc_getAssociatedObject(self, key) as? Associated<T>).map { $0.value }
    }
}
