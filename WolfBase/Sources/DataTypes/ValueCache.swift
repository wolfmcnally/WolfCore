//
//  ValueCache.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/10/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public final class ValueCache<N: Hashable> {
    private typealias `Self` = ValueCache
    public typealias NameType = N
    private typealias Dict = [NameType : Any]
    private var d: Dict
    
    public init() {
        d = Dict()
    }
    
    private init(d: Dict) {
        self.d = d
    }
    
    public func copy() -> ValueCache {
        return Self.init(d: d)
    }
    
    public func set<T>(_ key: NameType, to value: T) {
        d[key] = value
    }
    
    public func get<T>(_ key: NameType) -> T? {
        return d[key] as? T
    }
    
    public func get<T>(_ key: NameType, with update: () -> T) -> T {
        if let value = d[key] {
            return value as! T
        } else {
            let value = update()
            d[key] = value
            return value
        }
    }
    
    public func get<T>(_ key: NameType, _ update: @autoclosure () -> T) -> T {
        return get(key, with: update)
    }
    
    public func remove(_ key: NameType) {
        d[key] = nil
    }
    
    public func removeAll() {
        d.removeAll()
    }
}
