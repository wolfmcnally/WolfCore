//
//  DeviceOrientationAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/4/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class DeviceOrientationAction {
    public typealias ResponseBlock = (UIDeviceOrientation) -> Void
    private let action: ResponseBlock
    private var notificationAction: NotificationAction!
    
    public init(action: @escaping ResponseBlock) {
        self.action = action
        notificationAction = NotificationAction(name: .UIDeviceOrientationDidChange) { [unowned self] _ in
            self.action(UIDevice.current.orientation)
        }
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}
