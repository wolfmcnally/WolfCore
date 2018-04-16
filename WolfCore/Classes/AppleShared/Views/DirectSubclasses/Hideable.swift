//
//  Hideable.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/11/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public protocol Hideable: class {
    var isHidden: Bool { get set }
}

extension Hideable {
    public var isShown: Bool {
        get { return !isHidden }
        set { isHidden = !newValue }
    }

    public func show() {
        isHidden = false
    }

    public func hide() {
        isHidden = true
    }

    public func showIf(_ condition: Bool) {
        isHidden = !condition
    }

    public func hideIf(_ condition: Bool) {
        isHidden = condition
    }
}
