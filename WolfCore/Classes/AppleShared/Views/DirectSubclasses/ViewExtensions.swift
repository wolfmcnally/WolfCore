//
//  ViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

extension OSView: AnimatedHideable { }

extension OSView {
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

extension OSView {
    public func makeTransparent() {
        #if !os(macOS)
            isOpaque = false
            normalBackgroundColor = .clear
        #endif
    }

    public func __setup() {
        translatesAutoresizingMaskIntoConstraints = false
        makeTransparent()
    }
}
