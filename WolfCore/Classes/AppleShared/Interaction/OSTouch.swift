//
//  OSTouch.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com.
//

#if canImport(AppKit)
    import AppKit
    public typealias OSTouch = NSTouch
#elseif canImport(UIKit)
    import UIKit
    public typealias OSTouch = UITouch
#endif
