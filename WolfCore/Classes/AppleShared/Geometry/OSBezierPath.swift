//
//  OSBezierPath.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if canImport(Cocoa)
    import Cocoa
    public typealias OSBezierPath = NSBezierPath
#elseif canImport(UIKit)
    import UIKit
    public typealias OSBezierPath = UIBezierPath
#endif
