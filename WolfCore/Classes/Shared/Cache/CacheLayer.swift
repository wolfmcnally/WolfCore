//
//  CacheLayer.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation

public protocol CacheLayer {
    func store(data: Data, for url: URL)
    func retrieveData(for url: URL) -> DataPromise
    func removeData(for url: URL)
    func removeAll()
}
