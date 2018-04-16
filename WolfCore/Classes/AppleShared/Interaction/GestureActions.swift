//
//  GestureActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/5/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
    import AppKit
#else
    import UIKit
#endif

public class GestureActions {
    unowned let view: OSView
    var gestureRecognizerActions = [String: GestureRecognizerAction]()

    public init(view: OSView) {
        self.view = view
    }

    func getAction(for name: String) -> GestureBlock? {
        return gestureRecognizerActions[name]?.action
    }

    func setAction(named name: String, gestureRecognizer: OSGestureRecognizer, action: @escaping GestureBlock) {
        gestureRecognizerActions[name] = view.addAction(for: gestureRecognizer) { recognizer in
            action(recognizer)
        }
    }

    #if !os(macOS)
    func setSwipeAction(named name: String, direction: UISwipeGestureRecognizerDirection, action: GestureBlock?) {
        if let action = action {
            let recognizer = UISwipeGestureRecognizer()
            recognizer.direction = direction
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setPressAction(named name: String, press: UIPressType, action: GestureBlock?) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            recognizer.allowedPressTypes = [NSNumber(value: press.rawValue)]
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setTapAction(named name: String, action: GestureBlock?) {
        if let action = action {
            let recognizer = UITapGestureRecognizer()
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setLongPressAction(named name: String, action: GestureBlock?) {
        if let action = action {
            let recognizer = UILongPressGestureRecognizer()
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }
    #endif

    #if os(iOS)
    func setDeepPressAction(named name: String, action: GestureBlock?) {
        if let action = action {
            let recognizer = DeepPressGestureRecognizer()
            setAction(named: name, gestureRecognizer: recognizer, action: action)
        } else {
            removeAction(for: name)
        }
    }

    func setLongOrDeepPressAction(named name: String, action: GestureBlock?) {
        if let action = action {
            if hasForceTouch {
                let recognizer = DeepPressGestureRecognizer()
                setAction(named: name, gestureRecognizer: recognizer, action: action)
            } else {
                let recognizer = UILongPressGestureRecognizer()
                setAction(named: name, gestureRecognizer: recognizer, action: action)
            }
        } else {
            removeAction(for: name)
        }
    }
    #endif

    func removeAction(for name: String) {
        gestureRecognizerActions.removeValue(forKey: name)
    }
}
