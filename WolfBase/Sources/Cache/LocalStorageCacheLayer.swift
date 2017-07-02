//
//  LocalStorageCacheLayer.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

public class LocalStorageCacheLayer: CacheLayer {
  public let fileURL: URL
  public let sizeLimit: Int
  
  private var db: SQLite! = nil
  private let serializer = Serializer()
  
  public init?(fileURL: URL, sizeLimit: Int) {
    self.fileURL = fileURL
    self.sizeLimit = sizeLimit
    
    logInfo("init filename: \(fileURL.lastPathComponent), sizeLimit: \(sizeLimit)", obj: self, group: .cache)
    
    do {
      db = try SQLite(fileURL: fileURL)
      try db.exec(sql: "CREATE TABLE IF NOT EXISTS cache ( dateAccessed INTEGER NOT NULL, url TEXT UNIQUE NOT NULL, size INTEGER NOT NULL, data BLOB NOT NULL )")
      try db.exec(sql: "CREATE INDEX IF NOT EXISTS cacheURLIndex ON cache ( url )")
      try db.exec(sql: "CREATE INDEX IF NOT EXISTS cacheDateAccessedIndex ON cache ( dateAccessed )")
      
      try db.exec(sql: "CREATE TABLE IF NOT EXISTS admin ( key TEXT UNIQUE NOT NULL, value )")
      try db.exec(sql: "CREATE INDEX IF NOT EXISTS adminKeyIndex ON admin ( key )")
      try db.exec(sql: "INSERT OR IGNORE INTO admin ( key, value ) VALUES ( 'version', 0 )")
      try db.exec(sql: "INSERT OR IGNORE INTO admin ( key, value ) VALUES ( 'totalSize', 0 )")
    } catch let error {
      logError("Opening cache database: \(error), fileURL: \(fileURL)", obj: self)
      return nil
    }
  }
  
  public convenience init?(filename: String, sizeLimit: Int) {
    do {
      let fileManager = FileManager.default
      let cachesDirectory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      try fileManager.createDirectory(at: cachesDirectory, withIntermediateDirectories: true, attributes: nil)
      let fileURL = cachesDirectory.appendingPathComponent(filename)
      self.init(fileURL: fileURL, sizeLimit: sizeLimit)
    } catch let error {
      logError("Error initializing local storage cache: \(error)")
      return nil
    }
  }
  
  public func store(data: Data, for url: URL) {
    logTrace("storeData for: \(url)", obj: self, group: .cache)
    dispatchOnBackground {
      self.serializer.dispatch {
        self._store(data: data, for: url)
      }
    }
  }
  
  private func _store(data: Data, for url: URL) {
    
    // Get the current total size of the cache
    var totalSize: Int
    do {
      let statement = try db.prepare(sql: "SELECT value FROM admin WHERE key='totalSize'")
      switch try statement.step() {
      case .row:
        totalSize = statement.intValue(forColumnIndex: 0)
      case .done:
        logError("Could not get cache size.", obj: self)
        return
      }
    } catch let error {
      logError("Accessing cache size: \(error)", obj: self)
      return
    }
    
    // If the cache already contains an entry for the given URL
    do {
      let selectStatement = try db.prepare(sql: "SELECT rowid, size FROM cache WHERE url=:url")
      selectStatement.bindParameter(named: "url", toURL: url)
      switch try selectStatement.step() {
      case .row:
        // Delete the existing entry
        let rowID = selectStatement.intValue(forColumnIndex: 0)
        let size = selectStatement.intValue(forColumnIndex: 1)
        let deleteStatement = try db.prepare(sql: "DELETE FROM cache WHERE rowid=:rowID")
        deleteStatement.bindParameter(named: "rowID", toInt: rowID)
        try deleteStatement.step()
        totalSize -= size
      case .done:
        break
      }
    } catch let error {
      logError("Finding existing item: \(error).", obj: self)
      return
    }
    
    // If the cache is over the size limit
    let sizeNeeded = totalSize - sizeLimit
    if sizeNeeded > 0 {
      // Prune the cache
      do {
        let sizeReclaimed = try pruneCache(sizeNeeded: sizeNeeded)
        totalSize -= sizeReclaimed
      } catch let error {
        logError("Pruning cache: \(error).", obj: self)
        return
      }
    }
    
    // Calculate the new size of the cache including the item being added
    let dataLength = data.count
    totalSize += dataLength
    
    do {
      db.beginTransaction()
      
      // Add the new item to the cache
      do {
        let statement = try db.prepare(sql: "INSERT INTO cache ( dateAccessed, url, size, data ) VALUES ( CURRENT_TIMESTAMP, :url, :size, :data )")
        statement.bindParameter(named: "url", toURL: url)
        statement.bindParameter(named: "size", toInt: dataLength)
        statement.bindParameter(named: "data", toBLOB: data)
        try statement.step()
      } catch let error {
        logError("Storing cache object: \(error)", obj: self)
        throw error
      }
      
      // Store the updated size of the cache
      do {
        let statement = try db.prepare(sql: "UPDATE admin SET value=:totalSize WHERE key='totalSize'")
        statement.bindParameter(named: "totalSize", toInt: totalSize)
        try statement.step()
      } catch let error {
        logError("Updating total cache size: \(error)", obj: self)
        throw error
      }
      
      db.commitTransaction()
    } catch {
      db.rollbackTransaction()
    }
  }
  
  private func pruneCache(sizeNeeded: Int) throws -> Int {
    var sizeReclaimed = 0
    
    // Get the cache entries, sorted by least-recently-accessed first
    db.beginTransaction()
    do {
      let selectStatement = try db.prepare(sql: "SELECT url, size FROM cache ORDER BY dateAccessed")
      let deleteStatement = try db.prepare(sql: "DELETE FROM cache WHERE url=:url")
      loop: while sizeReclaimed < sizeNeeded {
        switch try selectStatement.step() {
        case .row:
          // Delete the least-recently-accessed entry and
          let url = selectStatement.urlValue(forColumnIndex: 0)!
          let size = selectStatement.intValue(forColumnIndex: 1)
          deleteStatement.bindParameter(named: "url", toURL: url)
          try deleteStatement.step()
          sizeReclaimed += size
          deleteStatement.reset()
        case .done:
          break loop
        }
      }
      db.commitTransaction()
    } catch let error {
      db.rollbackTransaction()
      throw error
    }
    
    return sizeReclaimed
  }
  
  public func retrieveData(for url: URL) -> DataPromise {
    func perform(promise: DataPromise) {
      logTrace("retrieveDataForURL: \(url)", obj: self, group: .cache)
      dispatchOnBackground {
        self.serializer.dispatch {
          _perform(promise: promise)
        }
      }
    }
    
    func _perform(promise: DataPromise) {
      do {
        let selectStatement = try db.prepare(sql: "SELECT data FROM cache where url=:url")
        selectStatement.bindParameter(named: "url", toURL: url)
        switch try selectStatement.step() {
        case .row:
          let data = selectStatement.blobValue(forColumnIndex: 0)!
          dispatchOnMain {
            promise.keep(data)
          }
          
          let updateStatement = try db.prepare(sql: "UPDATE cache SET dateAccessed=CURRENT_TIMESTAMP WHERE url=:url")
          updateStatement.bindParameter(named: "url", toURL: url)
          try updateStatement.step()
          
        case .done:
          dispatchOnMain {
            promise.fail(CacheError.miss(url))
          }
        }
      } catch let error {
        logError("Retrieving cache data for URL: \(url) error: \(error).", obj: self)
        dispatchOnMain {
          promise.fail(error)
        }
      }
    }
    
    return DataPromise(with: perform)
  }
  
  public func removeData(for url: URL) {
    logTrace("removeDataForURL: \(url)", obj: self, group: .cache)
    dispatchOnBackground {
      self.serializer.dispatch {
        self._removeData(for: url)
      }
    }
  }
  
  private func _removeData(for url: URL) {
    do {
      let deleteStatement = try db.prepare(sql: "DELETE FROM cache WHERE url=:url")
      deleteStatement.bindParameter(named: "url", toURL: url)
      try deleteStatement.step()
    } catch let error {
      logError("Removing cache data for URL: \(url) error: \(error).", obj: self)
    }
  }
  
  public func removeAll() {
    logTrace("removeAll", obj: self, group: .cache)
    dispatchOnBackground {
      self.serializer.dispatch {
        self._removeAll()
      }
    }
  }
  
  private func _removeAll() {
    do {
      db.beginTransaction()
      try db.exec(sql: "DELETE FROM cache")
      try db.exec(sql: "UPDATE admin SET value=0 WHERE key='totalSize'")
      db.commitTransaction()
    } catch let error {
      logError("Clearing cache: \(error).", obj: self)
      db.rollbackTransaction()
    }
  }
}
