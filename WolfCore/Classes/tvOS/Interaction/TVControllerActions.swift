//
//  TVControllerActions.swift
//  WolfCore_tvOS
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class TVControllerActions: GestureActions {
    private let swipeLeftName = "swipeLeft"
    private let swipeRightName = "swipeRight"
    private let swipeUpName = "swipeUp"
    private let swipeDownName = "swipeDown"
    // only used to obsolete remote
//    private let pressLeftName = "pressLeft"
//    private let pressRightName = "pressRight"
//    private let pressUpName = "pressUp"
//    private let pressDownName = "pressDown"
    private let pressPlayPauseName = "pressPlayPause"
    private let pressSelectName = "pressSelect"
    private let pressMenuName = "pressMenu"

    public var onSwipeLeft: GestureBlock? {
        get { return getAction(for: swipeLeftName) }
        set { setSwipeAction(named: swipeLeftName, direction: .left, action: newValue) }
    }

    public var onSwipeRight: GestureBlock? {
        get { return getAction(for: swipeRightName) }
        set { setSwipeAction(named: swipeRightName, direction: .right, action: newValue) }
    }

    public var onSwipeUp: GestureBlock? {
        get { return getAction(for: swipeUpName) }
        set { setSwipeAction(named: swipeUpName, direction: .up, action: newValue) }
    }

    public var onSwipeDown: GestureBlock? {
        get { return getAction(for: swipeDownName) }
        set { setSwipeAction(named: swipeDownName, direction: .down, action: newValue) }
    }

    // only used for obsolete remote
//    public var onPressLeft: GestureBlock? {
//        get { return getAction(for: pressLeftName) }
//        set { setPressAction(named: pressLeftName, press: .leftArrow, action: newValue) }
//    }
//
//    public var onPressRight: GestureBlock? {
//        get { return getAction(for: pressRightName) }
//        set { setPressAction(named: pressRightName, press: .rightArrow, action: newValue) }
//    }
//
//    public var onPressUp: GestureBlock? {
//        get { return getAction(for: pressUpName) }
//        set { setPressAction(named: pressLeftName, press: .upArrow, action: newValue) }
//    }
//
//    public var onPressDown: GestureBlock? {
//        get { return getAction(for: pressDownName) }
//        set { setPressAction(named: pressDownName, press: .downArrow, action: newValue) }
//    }

    public var onPressPlayPause: GestureBlock? {
        get { return getAction(for: pressPlayPauseName) }
        set { setPressAction(named: pressPlayPauseName, press: .playPause, action: newValue) }
    }

    public var onPressSelect: GestureBlock? {
        get { return getAction(for: pressSelectName) }
        set { setPressAction(named: pressSelectName, press: .select, action: newValue) }
    }

    public var onPressMenu: GestureBlock? {
        get { return getAction(for: pressMenuName) }
        set { setPressAction(named: pressMenuName, press: .menu, action: newValue) }
    }
}
