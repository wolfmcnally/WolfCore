//
//  Asynchronizer.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/31/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension LogGroup {
  public static let asynchronizer = LogGroup("asynchronizer")
}

public class Asynchronizer {
  public let name: String?
  private let delay: TimeInterval
  private let onSync: Block
  private var canceler: Cancelable?
  
  public init(name: String? = nil, delay: TimeInterval = 0.5, onSync: @escaping Block) {
    self.name = name
    self.delay = delay
    self.onSync = onSync
  }
  
  public func setNeedsSync() {
    logTrace("setNeedsSync", obj: self, group: .asynchronizer)
    _cancel()
    canceler = dispatchOnMain(afterDelay: delay) {
      self.sync()
    }
  }
  
  private func _cancel() {
    guard canceler != nil else { return }
    canceler?.cancel()
    canceler = nil
  }
  
  public func cancel() {
    logTrace("cancel", obj: self, group: .asynchronizer)
    _cancel()
  }
  
  public func syncIfNeeded() {
    logTrace("syncIfNeeded", obj: self, group: .asynchronizer)
    guard canceler != nil else { return }
    sync()
  }
  
  public func sync() {
    logTrace("sync", obj: self, group: .asynchronizer)
    _cancel()
    onSync()
  }
  
  deinit {
    _cancel()
  }
}

extension Asynchronizer: CustomStringConvertible {
  public var description: String {
    let s = ["Asynchronizer", name].flatJoined(separator: " ")
    return s
  }
}
