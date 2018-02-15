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
    private let longPressName = "longPress"
    private let deepPressName = "deepPress"
    private let longOrDeepPressName = "longOrDeepPress"

    public var onTap: GestureBlock? {
        get { return getAction(for: tapName) }
        set { setTapAction(named: tapName, action: newValue) }
    }

    public var onLongPress: GestureBlock? {
        get { return getAction(for: longPressName) }
        set { setLongPressAction(named: longPressName, action: newValue) }
    }

    #if !os(tvOS)
    public var onDeepPress: GestureBlock? {
        get { return getAction(for: deepPressName) }
        set { setDeepPressAction(named: longPressName, action: newValue) }
    }

    public var onLongOrDeepPress: GestureBlock? {
        get { return getAction(for: longOrDeepPressName) }
        set { setLongOrDeepPressAction(named: longOrDeepPressName, action: newValue) }
    }
    #endif
}
