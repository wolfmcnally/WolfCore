//
//  OSBezierPath.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation

#if canImport(AppKit)
    import AppKit
    public typealias OSBezierPath = NSBezierPath
#elseif canImport(UIKit)
    import UIKit
    public typealias OSBezierPath = UIBezierPath
#endif
