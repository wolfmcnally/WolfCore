//
//  FrameBaseSimulatorTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

//import XCTest
//@testable import WolfCore
//
//public struct ResultItem: Equatable {
//    let frameNumber: Int
//    let index: Int
//    let state: TestSystem.State
//    let duration: TimeInterval
//
//    public static func ==(lhs: ResultItem, rhs: ResultItem) -> Bool {
//        return lhs.frameNumber == rhs.frameNumber &&
//            lhs.index == rhs.index &&
//            lhs.state == rhs.state &&
//            abs(lhs.duration - rhs.duration) < 0.001
//    }
//}
//
//public class TestSystem: FrameBasedSystem {
//    public var results = [ResultItem]()
//
//    public init() { }
//
//    public enum State {
//        case on
//        case off
//    }
//
//    struct Event {
//        let state: State
//        let duration: TimeInterval
//    }
//
//    let events = [Event(state: .off, duration: 1.5),
//                  Event(state: .on , duration: 1.5),
//                  Event(state: .off, duration: 0.5),
//                  Event(state: .on , duration: 0.5),
//                  Event(state: .off, duration: 0.3),
//                  Event(state: .on , duration: 0.5),
//                  Event(state: .off, duration: 0.3),
//                  Event(state: .on , duration: 0.3),
//                  Event(state: .off, duration: 0.3),
//                  Event(state: .on , duration: 0.5),
//                  Event(state: .off, duration: 0.75),
//                  Event(state: .on , duration: 0.5),
//                  Event(state: .off, duration: 0.75)
//    ]
//
//    public var frameNumber: Int = 0
//
//    var eventIndex: Int!
//    var currentEvent: Event { return events[eventIndex] }
//
//    var timeBeforeTransition: TimeInterval = 0
//
//    public func simulate(forUpTo maxDuration: TimeInterval) -> (actualDuration: TimeInterval, timeBeforeTransition: TimeInterval) {
//        let actualDuration = min(maxDuration, timeBeforeTransition)
//        timeBeforeTransition -= actualDuration
//
//        //print("Event \(eventIndex!) simulatedFor: \(actualDuration %% 2)")
//        results.append(ResultItem(frameNumber: frameNumber, index: eventIndex, state: currentEvent.state, duration: actualDuration))
//
//        return (actualDuration, timeBeforeTransition)
//    }
//
//    public func transition() -> Bool {
//        if eventIndex == nil {
//            eventIndex = 0
//        } else {
//            eventIndex = eventIndex + 1
//        }
//        //print("Event \(eventIndex!) \(currentEvent.state)(\(currentEvent.duration %% 2))")
//        guard eventIndex < events.count else { return true }
//        timeBeforeTransition = currentEvent.duration
//        return false
//    }
//}
//
//class FrameBasedSimulatorTests: XCTestCase {
//    let correctResults: [ResultItem] = [
//        ResultItem(frameNumber: 1, index: 0, state: .off, duration: 1.0),
//        ResultItem(frameNumber: 2, index: 0, state: .off, duration: 0.5),
//        ResultItem(frameNumber: 2, index: 1, state: .on, duration: 0.5),
//        ResultItem(frameNumber: 3, index: 1, state: .on, duration: 0.9),
//        ResultItem(frameNumber: 4, index: 1, state: .on, duration: 0.1),
//        ResultItem(frameNumber: 4, index: 2, state: .off, duration: 0.5),
//        ResultItem(frameNumber: 4, index: 3, state: .on, duration: 0.4),
//        ResultItem(frameNumber: 5, index: 3, state: .on, duration: 0.1),
//        ResultItem(frameNumber: 5, index: 4, state: .off, duration: 0.3),
//        ResultItem(frameNumber: 5, index: 5, state: .on, duration: 0.5),
//        ResultItem(frameNumber: 5, index: 6, state: .off, duration: 0.3),
//        ResultItem(frameNumber: 5, index: 7, state: .on, duration: 0.1),
//        ResultItem(frameNumber: 6, index: 7, state: .on, duration: 0.2),
//        ResultItem(frameNumber: 6, index: 8, state: .off, duration: 0.3),
//        ResultItem(frameNumber: 6, index: 9, state: .on, duration: 0.5),
//        ResultItem(frameNumber: 7, index: 10, state: .off, duration: 0.75),
//        ResultItem(frameNumber: 7, index: 11, state: .on, duration: 0.25),
//        ResultItem(frameNumber: 8, index: 11, state: .on, duration: 0.25),
//        ResultItem(frameNumber: 8, index: 12, state: .off, duration: 0.75)
//    ]
//
//    func test1() {
//        let frameTimes: [TimeInterval] = [0.0, 1.0, 2.0, 2.9, 3.9, 5.2, 6.2, 7.2, 8.2]
//        let mySystem = TestSystem()
//        let sim = FrameBasedSimulator(system: mySystem)
//        for (frameNumber, currentTime) in frameTimes.enumerated() {
//            mySystem.frameNumber = frameNumber
//            //print("\nFrame \(frameNumber): \(currentTime)")
//            sim.update(to: currentTime)
//        }
//        XCTAssert(mySystem.results.count == correctResults.count)
//        for i in 0 ..< mySystem.results.count {
//            XCTAssert(mySystem.results[i] == correctResults[i])
//        }
//    }
//}
//
///*
// Frame 0: 0.0
// Event 0 off(1.5)
//
// Frame 1: 1.0
// Event 0 simulatedFor: 1
//
// Frame 2: 2.0
// Event 0 simulatedFor: 0.5
// Event 1 on(1.5)
// Event 1 simulatedFor: 0.5
//
// Frame 3: 2.9
// Event 1 simulatedFor: 0.9
//
// Frame 4: 3.9
// Event 1 simulatedFor: 0.1
// Event 2 off(0.5)
// Event 2 simulatedFor: 0.5
// Event 3 on(0.5)
// Event 3 simulatedFor: 0.4
//
// Frame 5: 5.2
// Event 3 simulatedFor: 0.1
// Event 4 off(0.3)
// Event 4 simulatedFor: 0.3
// Event 5 on(0.5)
// Event 5 simulatedFor: 0.5
// Event 6 off(0.3)
// Event 6 simulatedFor: 0.3
// Event 7 on(0.3)
// Event 7 simulatedFor: 0.1
//
// Frame 6: 6.2
// Event 7 simulatedFor: 0.2
// Event 8 off(0.3)
// Event 8 simulatedFor: 0.3
// Event 9 on(0.5)
// Event 9 simulatedFor: 0.5
// Event 10 off(0.75)
//
// Frame 7: 7.2
// Event 10 simulatedFor: 0.75
// Event 11 on(0.5)
// Event 11 simulatedFor: 0.25
//
// Frame 8: 8.2
// Event 11 simulatedFor: 0.25
// Event 12 off(0.75)
// Event 12 simulatedFor: 0.75
// */
//
