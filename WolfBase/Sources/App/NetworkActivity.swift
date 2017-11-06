//
//  NetworkActivity.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/17/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

public let networkActivity = NetworkActivity()

public class NetworkActivity {
    private let hysteresis: Hysteresis
    
    init() {
        hysteresis = Hysteresis( 
            onStart: {
                #if os(iOS)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                #endif
        },
            onEnd: {
                #if os(iOS)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                #endif
        },
            startLag: 0.2,
            endLag: 0.2
        )
    }
    
    public func newActivity() -> LockerCause {
        return hysteresis.newCause()
    }
}
