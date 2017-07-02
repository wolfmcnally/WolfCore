//
//  FrameBasedSimulator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

open class FrameBasedSimulator {
  public var system: FrameBasedSystem?
  public var isPaused: Bool = false {
    didSet {
      if isPaused == true {
        myTime = nil
      }
    }
  }

  public init(system: FrameBasedSystem? = nil) {
    self.system = system
  }

  private var myTime: TimeInterval!

  public func update(to currentTime: TimeInterval) {
    guard let system = system else { return }
    guard !isPaused else { return }

    if myTime == nil {
      myTime = currentTime
      _ = system.transition()
    }

    let elapsedTime = currentTime - myTime

    var remainingTime = elapsedTime
    while remainingTime > 0 && myTime < currentTime {
      let (actualDuration, timeBeforeTransition) = system.simulate(forUpTo: remainingTime)
      if timeBeforeTransition <= 0.0 {
        let done = system.transition()
        if done {
          isPaused = true
          break
        }
      }
      remainingTime -= actualDuration
      myTime = myTime + actualDuration
    }
  }

  public func invalidate() {
    system = nil
  }
}
