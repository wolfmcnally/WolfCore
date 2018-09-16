//
//  MemoryCacheLayer.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation
import WolfLog

public class MemoryCacheLayer: CacheLayer {

    private let cache = NSCache<NSURL, NSData>()

    public init() {
        logTrace("init", obj: self, group: .cache)
    }

    public func store(data: Data, for url: URL) {
        logTrace("storeData for: \(url)", obj: self, group: .cache)
        cache.setObject(data as NSData, forKey: url as NSURL)
    }

    public func retrieveData(for url: URL) -> DataPromise {
        func perform(promise: DataPromise) {
            logTrace("retrieveDataForURL: \(url)", obj: self, group: .cache)
            let data = cache.object(forKey: url as NSURL) as NSData?
            if let data = data {
                promise.keep(data as Data)
            } else {
                promise.fail(CacheError.miss(url))
            }
        }

        return DataPromise(with: perform)
    }

    public func removeData(for url: URL) {
        logTrace("removeDataForURL: \(url)", obj: self, group: .cache)
        cache.removeObject(forKey: url as NSURL)
    }

    public func removeAll() {
        logTrace("removeAll", obj: self, group: .cache)
        cache.removeAllObjects()
    }
}
