//
//  FrameBasedSystem.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol FrameBasedSystem {
    func simulate(forUpTo maxDuration: TimeInterval) -> (actualDuration: TimeInterval, timeBeforeTransition: TimeInterval)
    func transition() -> Bool
}
