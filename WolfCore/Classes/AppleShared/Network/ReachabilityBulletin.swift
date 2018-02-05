//
//  ReachabilityBulletin.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import SystemConfiguration
import Foundation

public class ReachabilityBulletin: MessageBulletin {
    private typealias `Self` = ReachabilityBulletin

    public let flags: SCNetworkReachabilityFlags

    public init(endpoint: Endpoint, flags: SCNetworkReachabilityFlags) {
        self.flags = flags

        let title: String
        let duration: TimeInterval?

        if flags.contains(.reachable) {
            title = "Your connection to #{endpointName} is now working." ¶ ["endpointName": endpoint.name]
            duration = 4
        } else {
            title = "There is a problem with your connection to #{endpointName}." ¶ ["endpointName": endpoint.name]
            duration = nil
        }

        super.init(title: title, priority: Self.maximumPriority, duration: duration)
    }
}
