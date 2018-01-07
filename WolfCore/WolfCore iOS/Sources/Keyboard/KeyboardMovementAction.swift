//
//  KeyboardMovementAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/22/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public typealias KeyboardMovementBlock = (KeyboardMovement) -> Void

public class KeyboardMovementAction: NotificationAction {
    public let keyboardMovementBlock: KeyboardMovementBlock

    public init(name: NSNotification.Name, using keyboardMovementBlock: @escaping KeyboardMovementBlock) {
        self.keyboardMovementBlock = keyboardMovementBlock
        super.init(name: name) { notification in
            let info = KeyboardMovement(notification: notification)
            keyboardMovementBlock(info)
        }
    }
}
