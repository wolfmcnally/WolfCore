//
//  KeyboardNotificationActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 WolfMcNally.com.
//

import UIKit

public class KeyboardNotificationActions {
    private var actions = [NSNotification.Name: KeyboardMovementAction]()

    public init() {
    }

    func getAction(named name: NSNotification.Name) -> KeyboardMovementBlock? {
        return actions[name]?.keyboardMovementBlock
    }

    func setAction(named name: NSNotification.Name, using block: KeyboardMovementBlock?) {
        if let block = block {
            let action = KeyboardMovementAction(name: name, using: block)
            actions[name] = action
        } else {
            removeAction(for: name)
        }
    }

    func removeAction(for name: NSNotification.Name) {
        actions.removeValue(forKey: name)
    }

    public var willChangeFrame: KeyboardMovementBlock? {
        get { return getAction(named: UIResponder.keyboardWillChangeFrameNotification) }
        set { setAction(named: UIResponder.keyboardWillChangeFrameNotification, using: newValue) }
    }

    public var willShow: KeyboardMovementBlock? {
        get { return getAction(named: UIResponder.keyboardWillShowNotification) }
        set { setAction(named: UIResponder.keyboardWillShowNotification, using: newValue) }
    }

    public var didShow: KeyboardMovementBlock? {
        get { return getAction(named: UIResponder.keyboardDidShowNotification) }
        set { setAction(named: UIResponder.keyboardDidShowNotification, using: newValue) }
    }

    public var willHide: KeyboardMovementBlock? {
        get { return getAction(named: UIResponder.keyboardWillHideNotification) }
        set { setAction(named: UIResponder.keyboardWillHideNotification, using: newValue) }
    }

    public var didHide: KeyboardMovementBlock? {
        get { return getAction(named: UIResponder.keyboardDidHideNotification) }
        set { setAction(named: UIResponder.keyboardDidHideNotification, using: newValue) }
    }
}
