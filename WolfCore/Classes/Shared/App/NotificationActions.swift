//
//  NotificationAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

open class NotificationActions {
    var notificationActions = [NSNotification.Name: NotificationAction]()

    public init() {
    }

    public func getAction(for name: NSNotification.Name) -> NotificationBlock? {
        return notificationActions[name]?.notificationBlock
    }

    public func setAction(using block: NotificationBlock?, object: AnyObject?, name: NSNotification.Name) {
        if let block = block {
            let notificationAction = NotificationAction(name: name, object: object, using: block)
            notificationActions[name] = notificationAction
        } else {
            removeAction(for: name)
        }
    }

    public func removeAction(for name: NSNotification.Name) {
        notificationActions.removeValue(forKey: name)
    }
}
