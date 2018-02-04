//
//  GestureRecognizerAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

private let gestureActionSelector = #selector(GestureRecognizerAction.gestureAction)

public typealias GestureBlock = (OSGestureRecognizer) -> Void

public class GestureRecognizerAction: NSObject, OSGestureRecognizerDelegate {
    public var action: GestureBlock?
    public let gestureRecognizer: OSGestureRecognizer
    public var shouldReceiveTouch: ((OSTouch) -> Bool)?
    public var shouldBegin: (() -> Bool)?

    public init(gestureRecognizer: OSGestureRecognizer, action: GestureBlock? = nil) {
        self.gestureRecognizer = gestureRecognizer
        self.action = action
        super.init()
        #if os(iOS) || os(tvOS)
            gestureRecognizer.addTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = self
            gestureRecognizer.action = gestureActionSelector
        #endif
        gestureRecognizer.delegate = self
    }
    
    deinit {
        #if os(iOS) || os(tvOS)
            gestureRecognizer.removeTarget(self, action: gestureActionSelector)
        #else
            gestureRecognizer.target = nil
            gestureRecognizer.action = nil
        #endif
    }

    @objc public func gestureAction() {
        action?(gestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: OSGestureRecognizer, shouldReceive touch: OSTouch) -> Bool {
        return shouldReceiveTouch?(touch) ?? true
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: OSGestureRecognizer) -> Bool {
        return shouldBegin?() ?? true
    }
}

extension OSView {
    public func addAction<G: OSGestureRecognizer>(forGestureRecognizer gestureRecognizer: G, action: @escaping (G) -> Void) -> GestureRecognizerAction {
        self.addGestureRecognizer(gestureRecognizer)
        return GestureRecognizerAction(gestureRecognizer: gestureRecognizer as OSGestureRecognizer, action: { recognizer in
            action(recognizer as! G)
        }
        )
    }
}

