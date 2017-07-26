//
//  Cache.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation
import CoreGraphics

public enum CacheError: Error {
  case miss(URL)
  case unsupportedEncoding(URL, String)
  case unsupportedContentType(URL, String)
  case badImageData(URL)
}

extension Error {
  public var isCacheMiss: Bool {
    guard let e = self as? CacheError else { return false }
    guard case .miss = e else { return false }
    return true
  }
}

extension LogGroup {
  public static let cache = LogGroup("cache")
}

public class Cache<T: Serializable> {
  public typealias SerializableType = T
  public typealias ValueType = T.ValueType
  
  private let layers: [CacheLayer]
  
  public init(layers: [CacheLayer]) {
    self.layers = layers
  }
  
  public convenience init(filename: String, sizeLimit: Int, includeHTTP: Bool) {
    
    #if !os(tvOS)
      var layers: [CacheLayer] = [
        MemoryCacheLayer(),
        LocalStorageCacheLayer(filename: filename, sizeLimit: sizeLimit)!,
        ]
    #else
      var layers: [CacheLayer] = [
        MemoryCacheLayer()
      ]
    #endif
    if includeHTTP {
      layers.append(HTTPCacheLayer())
    }
    self.init(layers: layers)
  }
  
  //    public func storeObject(obj: SerializableType, for url: URL, withSize size: CGSize) {
  //        let scale = mainScreenScale
  //
  //        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
  //        urlComponents?.queryItems = [
  //            URLQueryItem(name: "fit", value: "max"),
  //            URLQueryItem(name: "w", value: "\(Int(size.width * scale))"),
  //            URLQueryItem(name: "h", value: "\(Int(size.height * scale))"),
  //        ]
  //        if let url: URL = urlComponents?.url {
  //            logInfo("storeObject obj: \(obj), for: \(url)", obj: self, group: .cache)
  //            let data = obj.serialize()
  //            for layer in layers {
  //                layer.store(data: data, for: url)
  //            }
  //        } else {
  //            logError("storeObject obj: \(obj), for: \(url)", obj: self, group: .cache)
  //        }
  //    }
  
  public func store(obj: SerializableType, for url: URL) {
    logInfo("storeObject obj: \(obj), for: \(url)", obj: self, group: .cache)
    let data = obj.serialize()
    for layer in layers {
      layer.store(data: data, for: url)
    }
  }
  
  @discardableResult public func retrieveObject(for url: URL) -> Promise<ValueType> {
    logInfo("retrieveObjectForURL: \(url)", obj: self, group: .cache)
    return retrieveObject(at: 0, for: url)
  }
  
  public func removeObject(for url: URL) {
    logInfo("removeObjectForURL: \(url)", obj: self, group: .cache)
    for layer in layers {
      layer.removeData(for: url)
    }
  }
  
  public func removeAll() {
    logInfo("removeAll", obj: self, group: .cache)
    for layer in layers {
      layer.removeAll()
    }
  }
  
  private func retrieveObject(at layerIndex: Int, for url: URL) -> Promise<ValueType> {
    let layer = layers[layerIndex]
    return layer.retrieveData(for: url).then { data in
      do {
        let obj: ValueType = try SerializableType.deserialize(from: data)
        logInfo("Found object for URL: \(url) layer: \(layer)", obj: self, group: .cache)
        // If we found the data and successfully deserialized it, then store it in all the layers above this one
        for i in 0 ..< layerIndex {
          self.layers[i].store(data: data, for: url)
        }
        return obj
      } catch let error {
        logError("Could not deserialize data for URL: \(url) layer: \(layer) error: \(error)", obj: self)
        // If the data can't be deserialized then it's corrupt, so remove it from this layer and all the layers beneath it
        for i in layerIndex ..< self.layers.count {
          self.layers[i].removeData(for: url)
        }
        throw error
      }
      }.recover { (error, promise) in
        guard error.isCacheMiss else {
          promise.fail(error)
          return
        }
        
        guard layerIndex < self.layers.count - 1 else {
          promise.fail(CacheError.miss(url))
          return
        }
        
        self.retrieveObject(at: layerIndex + 1, for: url).then { value in
          promise.keep(value)
          }.catch { error in
            promise.fail(error)
          }.run()
    }
  }
}
