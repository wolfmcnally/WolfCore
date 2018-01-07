//
//  DeviceUtils.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
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

#if os(Linux) || os(macOS)
    public let isSimulator = false
#elseif arch(i386) || arch(x86_64)
    public let isSimulator = true
#else
    public let isSimulator = false
#endif
