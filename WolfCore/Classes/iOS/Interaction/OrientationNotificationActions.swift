//
//  OrientationNotificationActions.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com.
//

import UIKit

public class OrientationNotificationActions: NotificationActions {
    public var didChangeStatusBarOrientation: NotificationBlock? {
        get { return getAction(for: UIApplication.didChangeStatusBarOrientationNotification) }
        set { setAction(using: newValue, object: nil, name: UIApplication.didChangeStatusBarOrientationNotification) }
    }

    public var willChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(for: UIApplication.willChangeStatusBarFrameNotification) }
        set { setAction(using: newValue, object: nil, name: UIApplication.willChangeStatusBarFrameNotification) }
    }

    public var didChangeStatusBarFrame: NotificationBlock? {
        get { return getAction(for: UIApplication.didChangeStatusBarFrameNotification) }
        set { setAction(using: newValue, object: nil, name: UIApplication.didChangeStatusBarFrameNotification) }
    }

    public var backgroundRefreshStatusDidChange: NotificationBlock? {
        get { return getAction(for: UIApplication.backgroundRefreshStatusDidChangeNotification) }
        set { setAction(using: newValue, object: nil, name: UIApplication.backgroundRefreshStatusDidChangeNotification) }
    }
}
