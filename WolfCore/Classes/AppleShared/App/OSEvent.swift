//
//  OSEvent.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com.
//

#if canImport(AppKit)
    import AppKit
    public typealias OSEvent = NSEvent
#elseif canImport(UIKit)
    import UIKit
    public typealias OSEvent = UIEvent
#endif
