//
//  AnimatedHideable.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol AnimatedHideable: Hideable {
    var alpha: CGFloat { get set }
}

extension AnimatedHideable {
    public func hide(animated: Bool) {
        guard !isHidden else { return }
        dispatchAnimated(animated, options: [.beginFromCurrentState]) {
            self.alpha = 0
        }.then { _ in
            self.hide()
        }.run()
    }

    public func show(animated: Bool) {
        guard isHidden else { return }
        dispatchAnimated(animated, options: [.beginFromCurrentState]) {
            self.show()
            self.alpha = 1
        }.run()
    }

    public func showIf(_ condition: Bool, animated: Bool) {
        if condition {
            show(animated: animated)
        } else {
            hide(animated: animated)
        }
    }

    public func hideIf(_ condition: Bool, animated: Bool) {
        if condition {
            hide(animated: animated)
        } else {
            show(animated: animated)
        }
    }
}
