//
//  NotificationCenterExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/16/15.
//  Copyright © 2015 WolfMcNally.com.
//

import Foundation

public let notificationCenter = NotificationCenter.default
public typealias NotificationObserver = NSObjectProtocol
public typealias NotificationBlock = (Notification) -> Void

extension NotificationCenter {
    public func addObserver(for name: NSNotification.Name, object: AnyObject? = nil, using block: @escaping NotificationBlock) -> NotificationObserver {
        return self.addObserver(forName: name, object: object, queue: nil, using: block)
    }
}
