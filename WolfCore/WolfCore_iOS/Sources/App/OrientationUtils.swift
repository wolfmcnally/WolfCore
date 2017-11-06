//
//  OrientationInfo.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

extension UIInterfaceOrientationMask: CustomStringConvertible {
    public var description: String {
        let joiner = Joiner(left: "[", separator: ",", right: "]")
        if self.contains(.portrait) {
            joiner.append("portrait")
        }
        if self.contains(.landscapeLeft) {
            joiner.append("landscapeLeft")
        }
        if self.contains(.landscapeRight) {
            joiner.append("landscapeRight")
        }
        if self.contains(.portraitUpsideDown) {
            joiner.append("portraitUpsideDown")
        }
        return joiner.description
    }
}

extension UIDeviceOrientation: CustomStringConvertible {
    public var description: String {
        let s: String
        switch self {
        case .unknown:
            s = "unknown"
        case .portrait:
            s = "portrait"
        case .portraitUpsideDown:
            s = "portraitUpsideDown"
        case .landscapeLeft:
            s = "landscapeLeft"
        case .landscapeRight:
            s = "landscapeRight"
        case .faceUp:
            s = "faceUp"
        case .faceDown:
            s = "faceDown"
        }
        return "[\(s)]"
    }
}

extension UIDevice {
    public func force(toOrientation orientation: UIInterfaceOrientation) {
        setValue(orientation.rawValue, forKey: "orientation")
    }
    
    public static var currentOrientation: UIDeviceOrientation {
        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        defer { device.endGeneratingDeviceOrientationNotifications() }
        return device.orientation
    }
}

public func forcePhoneToPortraitOrientation() {
    if isPhone {
        UIDevice.current.force(toOrientation: .portrait)
    }
}

public func forceToPortraitOrientation() {
    UIDevice.current.force(toOrientation: .portrait)
}
