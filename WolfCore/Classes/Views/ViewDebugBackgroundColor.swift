//
//  ViewDebugBackgroundColor.swift
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


fileprivate struct AssociatedKeys {
    static var debug = "WolfCore_debug"
    static var debugBackgroundColor = "WolfCore_debugBackgroundColor"
    static var normalBackgroundColor = "WolfCore_normalBackgroundColor"
}

#if os(macOS)
    extension AssociatedKeys {
        static var backgroundColor = "WolfCore_backgroundColor"
    }
    
    extension OSView {
        public var backgroundColor: OSColor? {
            get {
                return getAssociatedValue(for: &AssociatedKeys.backgroundColor) ?? .red
            }
            
            set {
                setAssociatedValue(newValue, for: &AssociatedKeys.backgroundColor)
                _syncBackgroundColor()
            }
        }
    }
#endif

extension OSView {
    @objc open var isDebug: Bool {
        get {
            return getAssociatedValue(for: &AssociatedKeys.debug) ?? false
        }
        
        set {
            setAssociatedValue(newValue, for: &AssociatedKeys.debug)
            _syncBackgroundColor()
        }
    }
    
    public var debugBackgroundColor: OSColor? {
        get {
            return getAssociatedValue(for: &AssociatedKeys.debugBackgroundColor) ?? .red
        }
        
        set {
            setAssociatedValue(newValue, for: &AssociatedKeys.debugBackgroundColor)
            _syncBackgroundColor()
        }
    }
    
    public var normalBackgroundColor: OSColor? {
        get {
            return getAssociatedValue(for: &AssociatedKeys.normalBackgroundColor) ?? .yellow
        }
        
        set {
            setAssociatedValue(newValue, for: &AssociatedKeys.normalBackgroundColor)
            _syncBackgroundColor()
        }
    }
    
    private var _effectiveDebugBackgroundColor: OSColor {
        let n = Color(self.normalBackgroundColor!)
        let d = Color(self.debugBackgroundColor!)
        
        let n2 = blend(from: .white, to: n, at: n.alpha).withAlphaComponent(1)
        let d2 = d.withAlphaComponent(1)
        let c = blend(from: n2, to: d2, at: 0.5)
        let c2 = c.withAlphaComponent(0.5)
        return c2.osColor
    }
    
    public var effectiveBackgroundColor: OSColor? {
        return isDebug ? _effectiveDebugBackgroundColor : normalBackgroundColor
    }
    
    private func _syncBackgroundColor() {
        #if !os(macOS)
            backgroundColor = effectiveBackgroundColor
        #endif
    }
}

