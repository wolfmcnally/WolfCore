//
//  FrameBasedSimulator.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

//open class FrameBasedSimulator {
//    public weak var system: FrameBasedSystem?
//
//    public init(system: FrameBasedSystem? = nil) {
//        self.system = system
//    }
//
//    private var myTime: TimeInterval!
//
//    public func start() {
//        myTime = nil
//    }
//
//    public func update(deltaTime: TimeInterval) {
//        if myTime == nil {
//            myTime = 0
//        }
//
//        update(to: myTime + deltaTime)
//    }
//
//    public func update(to currentTime: TimeInterval) {
//        guard let system = system else { return }
//
//        if myTime == nil {
//            myTime = currentTime
//        }
//
//        let elapsedTime = currentTime - myTime
//
//        var remainingTime = elapsedTime
//        while remainingTime > 0 && myTime < currentTime {
//            let actualDuration = system.update(deltaTime: remainingTime)
//            assert(actualDuration <= remainingTime)
//            remainingTime -= actualDuration
//            myTime = myTime + actualDuration
//        }
//    }
//}

//open class FrameBasedSimulator {
//    public weak var system: FrameBasedSystem?
//
//    public init(system: FrameBasedSystem? = nil) {
//        self.system = system
//    }
//
//    private var myTime: TimeInterval!
//
//    public func start() {
//        myTime = nil
//        _ = system?.transition()
//    }
//
//    public func update(deltaTime: TimeInterval) {
//        if myTime == nil {
//            myTime = 0
//        }
//
//        update(to: myTime + deltaTime)
//    }
//
//    public func update(to currentTime: TimeInterval) {
//        guard let system = system else { return }
////        guard !isPaused else { return }
//
//        if myTime == nil {
//            myTime = currentTime
//        }
//
//        let elapsedTime = currentTime - myTime
//
//        var remainingTime = elapsedTime
//        while remainingTime > 0 && myTime < currentTime {
//            let (actualDuration, timeBeforeTransition) = system.simulate(forUpTo: remainingTime)
//            assert(actualDuration > 0 || timeBeforeTransition <= 0)
//            if timeBeforeTransition <= 0 {
//                system.transition()
//            }
//            remainingTime -= actualDuration
//            myTime = myTime + actualDuration
//        }
//    }
//
//    public func invalidate() {
//        system = nil
//    }
//}
