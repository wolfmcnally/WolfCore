//
//  RunLoopUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/18/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation

extension RunLoop {
    public func runOnce() {
        run(until: Date.distantPast)
    }
}
