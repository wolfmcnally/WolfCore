//
//  KeyboardNotificationActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

public class KeyboardNotificationActions {
  private var actions = Dictionary<NSNotification.Name, KeyboardMovementAction>()
  
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
    get { return getAction(named: .UIKeyboardWillChangeFrame) }
    set { setAction(named: .UIKeyboardWillChangeFrame, using: newValue) }
  }
  
  public var willShow: KeyboardMovementBlock? {
    get { return getAction(named: .UIKeyboardWillShow) }
    set { setAction(named: .UIKeyboardWillShow, using: newValue) }
  }
  
  public var didShow: KeyboardMovementBlock? {
    get { return getAction(named: .UIKeyboardDidShow) }
    set { setAction(named: .UIKeyboardDidShow, using: newValue) }
  }
  
  public var willHide: KeyboardMovementBlock? {
    get { return getAction(named: .UIKeyboardWillHide) }
    set { setAction(named: .UIKeyboardWillHide, using: newValue) }
  }
  
  public var didHide: KeyboardMovementBlock? {
    get { return getAction(named: .UIKeyboardDidHide) }
    set { setAction(named: .UIKeyboardDidHide, using: newValue) }
  }
}
