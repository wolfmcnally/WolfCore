//
//  InFlightTracker.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/26/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public internal(set) var inFlightTracker: InFlightTracker?

extension LogGroup {
    public static let inFlight = LogGroup("inFlight")
}

public class InFlightTracker {
    private let serializer = Serializer(label: "InFlightTracker")
    private var tokens = Set<InFlightToken>()
    public var didStart: ((InFlightToken) -> Void)?
    public var didEnd: ((InFlightToken) -> Void)?
    //    #if os(Linux)
    //    public var isHidden: Bool = false
    //    {
    //        didSet {
    //            syncToHidden()
    //        }
    //    }
    //    #else
    //    public var isHidden: Bool = {
    //        return !((userDefaults["DevInFlight"] as? Bool) ?? false)
    //    }()
    //    {
    //        didSet {
    //            syncToHidden()
    //        }
    //    }
    //    #endif

    //    #if os(Linux)
    //    public static func setup(withView: Bool = false) {
    //        inFlightTracker = InFlightTracker()
    //        inFlightTracker!.syncToHidden()
    //    }
    //    #endif

    //    #if !os(Linux)
    //    public static func setup(withView: Bool = false) {
    //        inFlightTracker = InFlightTracker()
    //        if withView {
    //            inFlightView = InFlightView()
    //            devOverlay => [
    //                inFlightView
    //            ]
    //            inFlightView.constrainFrameToFrame(identifier: "inFlight")
    //        }
    //        inFlightTracker!.syncToHidden()
    //    }
    //    #endif

    //    public func syncToHidden() {
    //        logTrace("syncToHidden: \(isHidden)", group: .inFlight)
    //        #if !os(Linux)
    //            inFlightView.hideIf(isHidden)
    //        #endif
    //    }

    public func start(withName name: String) -> InFlightToken {
        let token = InFlightToken(name: name)
        token.isNetworkActive = true
        didStart?(token)
        serializer.dispatch {
            self.tokens.insert(token)
        }
        logTrace("started: \(token)", group: .inFlight)
        return token
    }

    public func end(withToken token: InFlightToken, result: ResultSummary) {
        token.isNetworkActive = false
        token.result = result
        serializer.dispatch {
            if let token = self.tokens.remove(token) {
                logTrace("ended: \(token)", group: .inFlight)
            } else {
                fatalError("Token \(token) not found.")
            }
        }
        self.didEnd?(token)
    }
}

//private var testTokens = [InFlightToken]()
//
//public func testInFlightTracker() {
//    dispatchRepeatedOnMain(atInterval: 0.5) { canceler in
//        let n: Double = Random.number()
//        switch n {
//        case 0.0..<0.4:
//            let token = inFlightTracker!.start(withName: "Test")
//            testTokens.append(token)
//        case 0.4..<0.8:
//            if testTokens.count > 0 {
//                let index = Random.number(0..<testTokens.count)
//                let token = testTokens.remove(at: index)
//                let result = Random.boolean() ? Result<Int>.success(0) : Result<Int>.failure(GeneralError(message: "err"))
//                inFlightTracker!.end(withToken: token, result: result)
//            }
//        case 0.8..<1.0:
//            // do nothing
//            break
//        default:
//            break
//        }
//    }
//}
