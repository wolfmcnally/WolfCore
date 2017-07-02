//
//  DisplayLink.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation
import QuartzCore

public class DisplayLink {
  public typealias FiredBlock = (DisplayLink) -> ()
  public var firstTimestamp: CFTimeInterval!
  public var elapsedTime: CFTimeInterval { return timestamp - firstTimestamp }

  private var displayLink: CADisplayLink!
  private let onFired: FiredBlock

  public init(onFired: @escaping FiredBlock) {
    self.onFired = onFired
    displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
    displayLink.add(to: RunLoop.main, forMode: .commonModes)
  }

  deinit {
    displayLink.invalidate()
  }

  @objc private func displayLinkFired(displayLink: CADisplayLink) {
    if firstTimestamp == nil {
      firstTimestamp = timestamp
    }
    onFired(self)
  }

  public func invalidate() { displayLink.invalidate() }

  public var timestamp: CFTimeInterval { return displayLink.timestamp }
  public var duration: CFTimeInterval { return displayLink.duration }

  @available(iOS 10.0, *)
  public var targetTimestamp: CFTimeInterval {
    return displayLink.targetTimestamp
  }

  public var isPaused: Bool {
    get { return displayLink.isPaused }
    set { displayLink.isPaused = newValue }
  }

  @available(iOS 10.0, *)
  public var preferredFramesPerSecond: Int {
    get { return displayLink.preferredFramesPerSecond }
    set { displayLink.preferredFramesPerSecond = newValue }
  }
}

