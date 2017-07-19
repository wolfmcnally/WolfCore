//
//  Stopwatch.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public class Stopwatch {
  public private(set) var startTime: Date?
  public private(set) var stopTime: Date?
  
  public init() { }
  
  public func start() {
    startTime = Date()
    stopTime = nil
  }
  
  public func stop() {
    stopTime = Date()
    if startTime == nil { startTime = stopTime }
  }
  
  public var elapsedTime: TimeInterval? {
    guard let startTime = startTime else { return nil }
    let stopTime = self.stopTime ?? Date()
    return stopTime.timeIntervalSince(startTime)
  }

  public func after(_ timeInterval: TimeInterval, perform block: Block) {
    if elapsedTime! > timeInterval {
      block()
    }
  }

  public func every(_ timeInterval: TimeInterval, perform block: Block) {
    if elapsedTime! > timeInterval {
      block()
      start()
    }
  }
}
