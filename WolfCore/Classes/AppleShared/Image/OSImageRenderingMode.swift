//
//  OSImageRenderingMode.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(Cocoa)
    import Cocoa
    public enum OSImageRenderingMode: Int {
        case automatic
        case alwaysOriginal
        case alwaysTemplate
    }
#elseif canImport(UIKit)
    import UIKit
    public typealias OSImageRenderingMode = UIImageRenderingMode
#endif
