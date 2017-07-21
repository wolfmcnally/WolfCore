//
//  HTTPCacheLayer.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation
#if os(macOS)
  import AppKit
  public typealias OSImage = NSImage
#elseif !os(Linux)
  import UIKit
  public typealias OSImage = UIImage
#endif

#if !os(Linux)
// Support the Serializable protocol used for caching
extension OSImage: Serializable {
  public typealias ValueType = OSImage

  public func serialize() -> Data {
    return NSKeyedArchiver.archivedData(withRootObject: self)
  }

  public static func deserialize(from data: Data) throws -> OSImage {
    if let image = NSKeyedUnarchiver.unarchiveObject(with: data) as? OSImage {
      return image
    } else {
      throw ValidationError(message: "Invalid image data.", violation: "imageFormat")
    }
  }
}
#endif

public class HTTPCacheLayer: CacheLayer {
  public init() {
    logTrace("init", obj: self, group: .cache)
  }
  
  public func store(data: Data, for url: URL) {
    logTrace("storeData for: \(url)", obj: self, group: .cache)
    // Do nothing.
  }
  
  public func retrieveData(for url: URL) -> DataPromise {
    logTrace("retrieveDataForURL: \(url)", obj: self, group: .cache)
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    request.setMethod(.get)
    
    return HTTP.retrieveData(with: request).thenWith { promise in
      let task = promise.task as! URLSessionDataTask
      let response = task.response as! HTTPURLResponse
      
      var contentType: ContentType?
      if let contentTypeString = response.value(for: .contentType) {
        contentType = ContentType(rawValue: contentTypeString)
        guard contentType != nil else {
          throw CacheError.unsupportedContentType(url, contentType!.rawValue)
        }
      }
      
      let encoding = response.value(for: .encoding)
      
      guard encoding == nil else {
        throw CacheError.unsupportedEncoding(url, encoding!)
      }
      
      let data = promise.value!
//      return data

        if let contentType = contentType {
        switch contentType {
        case ContentType.jpg, ContentType.png, ContentType.gif:
          if let serializedImageData = OSImage(data: data)?.serialize() {
            return serializedImageData
          } else {
            throw CacheError.badImageData(url)
          }
        case ContentType.pdf:
          return data
        default:
          throw CacheError.unsupportedEncoding(url, contentType.rawValue)
        }
      } else {
        return data
      }
      }.recover { (error, promise) in
        if error.httpStatusCode == .notFound {
          promise.fail(CacheError.miss(url))
        } else {
          promise.fail(error)
        }
    }
  }
  
  public func removeData(for url: URL) {
    logTrace("removeDataForURL: \(url)", obj: self, group: .cache)
    // Do nothing.
  }
  
  public func removeAll() {
    logTrace("removeAll", obj: self, group: .cache)
    // Do nothing.
  }
}
