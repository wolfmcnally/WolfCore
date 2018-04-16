//
//  DeviceUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if canImport(Cocoa)
import Cocoa
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

public var osVersion: String {
    let os = ProcessInfo().operatingSystemVersion
    return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
}

public var deviceModel: String? {
    let utsSize = MemoryLayout<utsname>.size
    var systemInfo = Data(capacity: utsSize)

    let model: String? = systemInfo.withUnsafeMutableBytes { (uts: UnsafeMutablePointer<utsname>) in
        guard uname(uts) == 0 else { return nil }
        return uts.withMemoryRebound(to: CChar.self, capacity: utsSize) { String(cString: $0) }
    }

    return model
}

public var deviceName: String {
    #if os(Linux)
        return Host.current().localizedName ?? ""
    #elseif os(macOS)
        fatalError("Unimplemented.")
    #elseif os(watchOS)
        fatalError("Unimplemented.")
    #else
        return UIDevice.current.name
    #endif
}

public var mainScreenScale: CGFloat {
    #if os(iOS) || os(tvOS)
        return UIScreen.main.scale
    #elseif os(macOS)
        return NSScreen.main!.backingScaleFactor
    #else
        return 1.0
    #endif
}

#if os(macOS)
    public let defaultIsFlipped = false
#else
    public let defaultIsFlipped = true
#endif

#if os(iOS) || os(tvOS)
    public let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    public let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    public let isTV: Bool = UIDevice.current.userInterfaceIdiom == .tv
    public let isCarPlay: Bool = UIDevice.current.userInterfaceIdiom == .carPlay

    public var defaultTintColor: UIColor = {
        return UIView().tintColor!
    }()
#endif

#if os(iOS)
    public let hasForceTouch = UIScreen.main.traitCollection.forceTouchCapability == .available
#endif
