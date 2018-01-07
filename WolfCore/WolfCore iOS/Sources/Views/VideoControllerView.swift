//
//  VideoControllerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

extension LogGroup {
    public static let video = LogGroup("video")
}

open class VideoControllerView: View {
    public typealias UpdatePositionBlock = (_ position: TimeInterval, _ duration: TimeInterval) -> Void
    public var onUpdatePosition: UpdatePositionBlock?
    public var onEnterFullscreen: Block?
    public var onExitFullscreen: Block?
    public var contentView: UIView!
    
    public required init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public enum Mode {
        case foreground
        case background
    }
    
    public var mode: Mode = .foreground {
        didSet {
            syncToMode()
        }
    }
    
    open func syncToMode() { }
    
    public enum State {
        case paused(Int)
        case playing
        case complete
        case stopped
    }
    
    private var _state: State = .paused(1)
    
    public func setState(_ state: State, animated: Bool) {
        _state = state
        syncToState(animated: animated)
    }
    
    public var state: State {
        return _state
    }
    
    //    public var state: State = .paused(1) {
    //        didSet {
    //            syncToState(animated: false)
    //        }
    //    }
    
    open func syncToState(animated: Bool) {
        switch state {
        case .playing:
            logTrace("PLAYING", group: .video)
        case .paused(let level):
            logTrace("PAUSED (\(level))", group: .video)
        case .complete:
            logTrace("COMPLETE", group: .video)
        case .stopped:
            logTrace("STOPPED", group: .video)
        }
    }
    
    open var position: TimeInterval {
        return 0
    }
    
    open func play(animated: Bool, reason: String) {
        logTrace("play (\(reason))", group: .video)
        
        switch state {
        case .playing, .complete:
            setState(.playing, animated: animated)
        case .paused(let level):
            switch level {
            case 1:
                setState(.playing, animated: animated)
            default:
                setState(.paused(level - 1), animated: animated)
            }
        case .stopped:
            break
        }
    }
    
    open func pauseIfNeeded(animated: Bool, reason: String) {
        switch state {
        case .playing:
            pause(animated: animated, reason: reason)
        default:
            break
        }
    }
    
    open func pause(animated: Bool, reason: String) {
        logTrace("pause (\(reason))", group: .video)
        
        switch state {
        case .playing:
            setState(.paused(1), animated: animated)
        case .paused(let level):
            setState(.paused(level + 1), animated: animated)
        case .complete, .stopped:
            break
        }
    }
    
    open func stop(animated: Bool, reason: String) {
        logTrace("stop (\(reason))", group: .video)
        setState(.stopped, animated: animated)
    }
    
    open func toggle(animated: Bool) {
        switch state {
        case .playing:
            pause(animated: animated, reason: "toggled")
        case .paused, .complete:
            play(animated: animated, reason: "toggled")
        case .stopped:
            break
        }
    }
    
    open func seek(to time: TimeInterval) {
        logTrace("seek to: (\(time))", group: .video)
    }
    
    open func review(secondsBack: TimeInterval) {
        logTrace("review secondsBack: (\(time))", group: .video)
    }
    
    open var fileURL: URL!
    
    open var posterURL: URL!
    
    open var volume: Frac = 1.0
    
    open var forceFullscreenOnLandscape: Bool = false
    
    open var isInFullscreen: Bool { return false }
}
