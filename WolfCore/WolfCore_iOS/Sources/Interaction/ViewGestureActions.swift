//
//  ViewGestureActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/5/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

public class ViewGestureActions: GestureActions {
  private let tapName = "tap"
  
  public var onTap: GestureBlock? {
    get { return getAction(for: tapName) }
    set { setTapAction(named: tapName, action: newValue) }
  }
}
