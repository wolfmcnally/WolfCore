//
//  Timeline.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase
import Foundation

extension LogGroup {
  public static let timeline = LogGroup("timeline")
}

public class Timeline {
  private var events = [Event]()
  private var notifyWorkItem: DispatchWorkItem?
  private var displayLink: DisplayLink?
  private var nextEventIndex: Int = 0

  public init() {
  }

  private class Event: Comparable, CustomStringConvertible {
    let time: TimeInterval
    let name: String
    private let action: Block
    var executeTime: TimeInterval?

    init(at time: TimeInterval, named name: String, action: @escaping Block) {
      self.time = time
      self.name = name
      self.action = action
    }

    public static func == (lhs: Event, rhs: Event) -> Bool { return lhs.time == rhs.time }
    public static func < (lhs: Event, rhs: Event) -> Bool { return lhs.time < rhs.time }

    public var description: String {
      return "\(name) (\(time %% 3))"
    }

    func execute(at executeTime: CFTimeInterval) {
      self.executeTime = executeTime
      logTrace("\(name) (\(executeTime %% 3) - \(time %% 3) = \((executeTime - time) %% 3))", group: .timeline)
      action()
    }
  }

  public func addEvent(at time: TimeInterval, named name: String, action: @escaping Block) {
    let event = Event(at: time, named: name, action: action)
    events.append(event)
  }

  private func finish() {
    displayLink?.invalidate()
  }

  private func executeCurrentEvents(elapsedTime: CFTimeInterval) {
    while true {
      guard nextEventIndex < events.count else { finish(); return }
      let event = events[nextEventIndex]
      if elapsedTime >= event.time {
        event.execute(at: elapsedTime)
        nextEventIndex += 1
        if nextEventIndex == events.count { finish(); break }
      } else {
        break
      }
    }
  }

  public func play() {
    events.sort(by: <)
    nextEventIndex = 0
    displayLink = DisplayLink() { [unowned self] displayLink in
      self.executeCurrentEvents(elapsedTime: displayLink.elapsedTime)
    }
  }

  public func cancel() {
    finish()
  }
}

