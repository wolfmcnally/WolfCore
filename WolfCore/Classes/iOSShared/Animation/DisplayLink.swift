//
//  DisplayLink.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com.
//

public class DisplayLink: Invalidatable {
    public typealias FiredBlock = (DisplayLink) -> Void
    public var firstTimestamp: CFTimeInterval!
    public var elapsedTime: CFTimeInterval { return timestamp - firstTimestamp }

    private var displayLink: CADisplayLink!
    private let onFired: FiredBlock

    public init(preferredFramesPerSecond: Int = 30, onFired: @escaping FiredBlock) {
        self.onFired = onFired
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        if #available(iOS 10.0, *) {
            displayLink.preferredFramesPerSecond = min(60, preferredFramesPerSecond)
        }
        displayLink.add(to: RunLoop.main, forMode: .common)
    }

    deinit {
        displayLink.invalidate()
    }

    @objc private func displayLinkFired(displayLink: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = timestamp
        }

//        if #available(iOS 10.0, *) {
//        print( 1.0 / (displayLink.targetTimestamp - displayLink.timestamp))
//        }

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
