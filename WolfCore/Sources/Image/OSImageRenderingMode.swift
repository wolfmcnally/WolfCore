//
//  OSImageRenderingMode.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public enum OSImageRenderingMode: Int {
        case automatic
        case alwaysOriginal
        case alwaysTemplate
    }
#else
    import UIKit
    public typealias OSImageRenderingMode = UIImageRenderingMode
#endif
