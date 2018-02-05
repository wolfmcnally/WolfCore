//
//  Reachability.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation
import SystemConfiguration

extension LogGroup {
    public static let reachability = LogGroup("reachability")
}

public class Reachability {
    private typealias `Self` = Reachability

    public let endpoint: Endpoint
    public let publisher = Publisher<Bulletin>()

    private let networkReachability: SCNetworkReachability
    private var context = SCNetworkReachabilityContext()

    private var currentBulletin: ReachabilityBulletin? {
        willSet {
            guard let currentBulletin = currentBulletin else { return }
            publisher.unpublish(currentBulletin)
        }

        didSet {
            guard let currentBulletin = currentBulletin else { return }
            publisher.publish(currentBulletin)
        }
    }

    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
        let data = endpoint.host |> Data.init
        networkReachability = data.withUnsafeBytes {
            return SCNetworkReachabilityCreateWithName(nil, $0)!
        }
    }

    public func start() {
        context.info = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        SCNetworkReachabilitySetCallback(networkReachability, reachabilityCallback, &context)
        assert(SCNetworkReachabilitySetDispatchQueue(networkReachability, mainQueue))
    }

    private var currentFlags: SCNetworkReachabilityFlags {
        var f = SCNetworkReachabilityFlags()
        _ = SCNetworkReachabilityGetFlags(networkReachability, &f)
        return f
    }

    public private(set) var flags: SCNetworkReachabilityFlags? {
        didSet {
            setNeedsSyncBulletin()
        }
    }

    private var cancelSync: Cancelable?

    private func setNeedsSyncBulletin() {
        cancelSync?.cancel()
        cancelSync = dispatchOnMain(afterDelay: 0.25) { [unowned self] in
            self.syncBulletin()
        }
    }

    fileprivate func didUpdate(with flags: SCNetworkReachabilityFlags) {
        logTrace("Network Reachability for \(endpoint.name) (\(endpoint.host))): \(flags)", group: .reachability)
        self.flags = flags
    }

    private func syncBulletin() {
        guard let flags = flags else { return }
        if currentBulletin?.flags.contains(.reachable) != flags.contains(.reachable) {
            guard currentBulletin != nil || !flags.contains(.reachable) else { return }
            currentBulletin = ReachabilityBulletin(endpoint: endpoint, flags: flags)
        }
    }
}

private func reachabilityCallback(_ target: SCNetworkReachability, _ flags: SCNetworkReachabilityFlags, _ info: UnsafeMutableRawPointer?) {
    let info = info!
    let reachability = unsafeBitCast(info, to: Reachability.self)
    reachability.didUpdate(with: flags)
}

extension SCNetworkReachabilityFlags: CustomStringConvertible {
    public var description: String {
        var strings = [String]()
        if contains(.transientConnection) { strings.append(".transientConnection") }
        if contains(.reachable) { strings.append(".reachable") }
        if contains(.connectionRequired) { strings.append(".connectionRequired") }
        if contains(.connectionOnTraffic) { strings.append(".connectionOnTraffic") }
        if contains(.interventionRequired) { strings.append(".interventionRequired") }
        if contains(.connectionOnDemand) { strings.append(".connectionOnDemand") }
        if contains(.isLocalAddress) { strings.append(".isLocalAddress") }
        if contains(.isDirect) { strings.append(".isDirect") }
        #if !os(macOS)
            if contains(.isWWAN) { strings.append(".isWWAN") }
        #endif
        return strings.joined(separator: ", ")
    }
}
