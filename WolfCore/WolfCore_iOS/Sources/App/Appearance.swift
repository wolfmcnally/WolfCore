//
//  Appearance.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 11/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation
import UIKit
import WolfBase

//
// Based on:
// https://github.com/victor-pavlychko/SwiftyAppearance
//

public extension NSNotification.Name {
    public static let appearanceWillRefreshApplication = NSNotification.Name(rawValue: "appearanceWillRefreshApplicationNotification")
    public static let appearanceDidRefreshApplication = NSNotification.Name(rawValue: "appearanceDidRefreshApplicationNotification")
    public static let appearanceWillRefreshWindow = NSNotification.Name(rawValue: "appearanceWillRefreshWindowNotification")
    public static let appearanceDidRefreshWindow = NSNotification.Name(rawValue: "appearanceDidRefreshWindowNotification")
}

public extension UIApplication {
    @nonobjc private func _refreshAppearance(animated: Bool) {
        for window in windows {
            window.refreshAppearance(animated: animated)
        }
    }

    public func refreshAppearance(animated: Bool) {
        notificationCenter.post(name: .appearanceWillRefreshApplication, object: self)
        dispatchAnimated {
            self._refreshAppearance(animated: animated)
        }.finally {
            notificationCenter.post(name: .appearanceDidRefreshApplication, object: self)
        }.run()
    }
}

public extension UIWindow {
    @nonobjc private func _refreshAppearance() {
        let constraints = self.constraints
        removeConstraints(constraints)
        for subview in subviews {
            subview.removeFromSuperview()
            addSubview(subview)
        }
        addConstraints(constraints)
    }

    public func refreshAppearance(animated: Bool) {
        notificationCenter.post(name: .appearanceWillRefreshWindow, object: self)
        dispatchAnimated {
            self._refreshAppearance()
        }.finally {
            notificationCenter.post(name: .appearanceDidRefreshWindow, object: self)
        }.run()
    }
}

internal struct AppearanceScope {
    internal static var main = AppearanceScope()

    private enum StackElement {
        case traitCollection(UITraitCollection)
        case containerTypes([UIAppearanceContainer.Type])
    }

    private var _stack: [StackElement] = []

    internal struct Context {
        internal let traitCollection: UITraitCollection?
        internal let containerTypes: [UIAppearanceContainer.Type]?

        internal init(_ traitCollections: [UITraitCollection], _ containerTypes: [UIAppearanceContainer.Type]) {
            self.traitCollection = traitCollections.isEmpty ? nil : UITraitCollection(traitsFrom: traitCollections)
            self.containerTypes = containerTypes.isEmpty ? nil : containerTypes.reversed()
        }
    }

    internal var context: Context {
        var traitCollections: [UITraitCollection] = []
        var containerTypes: [UIAppearanceContainer.Type] = []
        for element in _stack {
            switch element {
            case let .traitCollection(element):
                traitCollections.append(element)
            case let .containerTypes(element):
                containerTypes.append(contentsOf: element)
            }
        }
        return Context(traitCollections, containerTypes)
    }

    internal mutating func push(_ traitCollection: UITraitCollection) {
        _stack.append(.traitCollection(traitCollection))
    }

    internal mutating func push(_ containerType: UIAppearanceContainer.Type) {
        _stack.append(.containerTypes([containerType]))
    }

    internal mutating func push(_ containerTypes: [UIAppearanceContainer.Type]) {
        _stack.append(.containerTypes(containerTypes))
    }

    internal mutating func pop() {
        _stack.removeLast()
    }
}

internal extension UIAppearance {
    internal static func appearance(context: AppearanceScope.Context) -> Self {
        switch (context.traitCollection, context.containerTypes) {
        case let (.some(traitCollection), .some(containerTypes)):
            return appearance(for: traitCollection, whenContainedInInstancesOf: containerTypes)
        case let (.some(traitCollection), .none):
            return appearance(for: traitCollection)
        case let (.none, .some(containerTypes)):
            return appearance(whenContainedInInstancesOf: containerTypes)
        case (.none, .none):
            return appearance()
        }
    }
}

public protocol AppearanceStyleable: NSObjectProtocol {
    associatedtype Style: RawRepresentable
    var appearanceRoot: UIWindow? { get }
}

public extension AppearanceStyleable where Self.Style.RawValue == String {
    public static func style(_ style: Style) -> Self.Type {
        return _styleClass(name: style.rawValue)
    }

    public var style: Style? {
        get { return Style(rawValueOrNil: Self._styleName(class: object_getClass(self)!)) }
        set { setStyle(newValue, animated: false) }
    }

    public func setStyle(_ style: Style?, animated: Bool) {
        object_setClass(self, Self._styleClass(name: style?.rawValue))
        appearanceRoot?.refreshAppearance(animated: animated)
    }
}

public extension AppearanceStyleable where Self: UIView {
    public var appearanceRoot: UIWindow? {
        return window
    }
}

public extension AppearanceStyleable where Self: UIWindow {
    public var appearanceRoot: UIWindow? {
        return self
    }
}

public extension AppearanceStyleable where Self: UIViewController {
    public var appearanceRoot: UIWindow? {
        return viewIfLoaded?.window
    }
}

fileprivate extension RawRepresentable {
    fileprivate init?(rawValueOrNil: RawValue?) {
        guard let rawValue = rawValueOrNil else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
}

fileprivate extension AppearanceStyleable {
    private static var _subclassPrefix: String {
        return "__Appearance_\(String(cString: class_getName(Self.self)))_style_"
    }

    private static func _lookUpClass(_ className: String) -> AnyClass? {
        return className.withCString { objc_lookUpClass($0) }
    }

    private static func _allocateClassPair(_ superclass: AnyClass, _ className: String, _ extraBytes: Int) -> AnyClass? {
        return className.withCString { objc_allocateClassPair(superclass, $0, extraBytes) }
    }

    fileprivate static func _styleClass(name styleName: String?) -> Self.Type {
        guard let subclassName = styleName.flatMap({ _subclassPrefix + $0 }) else {
            return Self.self
        }
        if let subclass = _lookUpClass(subclassName) as? Self.Type {
            return subclass
        }
        if let subclass = _allocateClassPair(Self.self, subclassName, 0) as? Self.Type {
            objc_registerClassPair(subclass)
            return subclass
        }
        fatalError("Appearance: failed to subclass \(Self.self) as `\(subclassName)`")
    }

    fileprivate static func _styleName(class styleClass: AnyClass) -> String? {
        let subclassName = String(cString: class_getName(styleClass))
        let subclassPrefix = _subclassPrefix
        guard subclassName.hasPrefix(subclassPrefix) else {
            return nil
        }
        return String(subclassName[subclassPrefix.endIndex.samePosition(in: subclassName)!...])
//        return subclassName.substring(from: subclassPrefix.endIndex.samePosition(in: subclassName))
    }
}
/// Nested appearance scope for specified trait collection
///
/// - Parameters:
///   - traits: trait collection
///   - block:  appearance code block
public func appearance(for traits: UITraitCollection, _ block: () -> Void) {
    AppearanceScope.main.push(traits)
    block()
    AppearanceScope.main.pop()
}

/// Nested appearance scope for specified trait
///
/// - Parameters:
///   - trait: trait element
///   - block: appearance code block
public func appearance(for trait: UITraitCollection.Trait, _ block: () -> Void) {
    appearance(for: UITraitCollection(trait: trait), block)
}

/// Nested appearance scope for specified trait list
///
/// - Parameters:
///   - traits: trait element list
///   - block:  appearance code block
public func appearance(for traits: [UITraitCollection.Trait], _ block: () -> Void) {
    appearance(for: UITraitCollection(traits: traits), block)
}

/// Nested appearance scope for specified container type
///
/// - Parameters:
///   - containerType: container type
///   - block:         appearance code block
public func appearance(in containerType: UIAppearanceContainer.Type, _ block: () -> Void) {
    AppearanceScope.main.push(containerType)
    block()
    AppearanceScope.main.pop()
}

/// Nested appearance scope for specified container chain
///
/// - Parameters:
///   - containerTypes: container chain
///   - block:          appearance code block
public func appearance(inChain containerTypes: [UIAppearanceContainer.Type], _ block: () -> Void) {
    AppearanceScope.main.push(containerTypes)
    block()
    AppearanceScope.main.pop()
}

/// Nested appearance scope for any of specified containers
///
/// - Parameters:
///   - containerTypes: list of containers
///   - block:          appearance code block
public func appearance(inAny containerTypes: [UIAppearanceContainer.Type], _ block: () -> Void) {
    for container in containerTypes {
        appearance(in: container, block)
    }
}

public extension UIAppearanceContainer {

    /// Nested appearance scope for `Self` container
    ///
    /// - Parameter block: appearance code block for current container
    public static func appearance(_ block: () -> Void) {
        AppearanceScope.main.push(self)
        block()
        AppearanceScope.main.pop()
    }
}

public extension UIAppearance where Self: UIAppearanceContainer {

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for `Self` container
    ///
    /// - Parameters:
    ///   - block: appearance code block for current container
    ///   - proxy: appearance proxy to configure
    public static func appearance(_ block: (_ proxy: Self) -> Void) {
        let context = AppearanceScope.main.context
        let proxy = appearance(context: context)
        AppearanceScope.main.push(self)
        block(proxy)
        AppearanceScope.main.pop()
    }
}

public extension UIAppearance {

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for `Self` container if applicable
    ///
    /// - Parameters:
    ///   - block: appearance code block for current container
    ///   - proxy: appearance proxy to configure
    public static func appearance(_ block: (_ proxy: Self) -> Void) {
        let context = AppearanceScope.main.context
        let proxy = appearance(context: context)
        if let selfContainerType = self as? UIAppearanceContainer.Type {
            AppearanceScope.main.push(selfContainerType)
            block(proxy)
            AppearanceScope.main.pop()
        } else {
            block(proxy)
        }
    }

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for `Self` container with specified trait collection
    ///
    /// - Parameters:
    ///   - traits: trait collections
    ///   - block:  appearance code block for current container
    ///   - proxy:  appearance proxy to configure
    public static func appearance(for traits: UITraitCollection, _ block: (_ proxy: Self) -> Void) {
        AppearanceScope.main.push(traits)
        appearance(block)
        AppearanceScope.main.pop()
    }

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for specified trait
    ///
    /// - Parameters:
    ///   - trait: trait element
    ///   - block: appearance code block
    public static func appearance(for trait: UITraitCollection.Trait, _ block: (_ proxy: Self) -> Void) {
        appearance(for: UITraitCollection(trait: trait), block)
    }

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for specified trait list
    ///
    /// - Parameters:
    ///   - traits: trait element list
    ///   - block:  appearance code block
    public static func appearance(for traits: [UITraitCollection.Trait], _ block: (_ proxy: Self) -> Void) {
        appearance(for: UITraitCollection(traits: traits), block)
    }

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for `Self` container inside specified container type
    ///
    /// - Parameters:
    ///   - containerType: container type
    ///   - block:         appearance code block for current container
    ///   - proxy:         appearance proxy to configure
    public static func appearance(in containerType: UIAppearanceContainer.Type, _ block: (_ proxy: Self) -> Void) {
        AppearanceScope.main.push(containerType)
        appearance(block)
        AppearanceScope.main.pop()
    }

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for `Self` container inside specified container chain
    ///
    /// - Parameters:
    ///   - containerTypes: container chain
    ///   - block:          appearance code block for current container
    ///   - proxy:          appearance proxy to configure
    public static func appearance(inChain containerTypes: [UIAppearanceContainer.Type], _ block: (_ proxy: Self) -> Void) {
        AppearanceScope.main.push(containerTypes)
        appearance(block)
        AppearanceScope.main.pop()
    }

    /// Configure appearance for `Self` type and start
    /// nested appearance scope for `Self` container inside any of specified containers
    ///
    /// - Parameters:
    ///   - containerTypes: list of containers
    ///   - block:          appearance code block for current container
    ///   - proxy:          appearance proxy to configure
    public static func appearance(inAny containerTypes: [UIAppearanceContainer.Type], _ block: (_ proxy: Self) -> Void) {
        for container in containerTypes {
            appearance(in: container, block)
        }
    }
}
