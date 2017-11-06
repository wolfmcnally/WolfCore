//
//  DeviceUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public var mainScreenScale: CGFloat {
    #if os(iOS) || os(tvOS)
        return UIScreen.main.scale
    #elseif os(macOS)
        return NSScreen.main!.backingScaleFactor
    #else
        return 1.0
    #endif
}

#if os(iOS) || os(tvOS)

    public let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    public let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    public let isTV: Bool = UIDevice.current.userInterfaceIdiom == .tv
    public let isCarPlay: Bool = UIDevice.current.userInterfaceIdiom == .carPlay

    public var defaultTintColor: UIColor = {
        return UIView().tintColor!
    }()

#endif
