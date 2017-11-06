//
//  Constraints.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/7/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

import WolfBase

extension LogGroup {
    public static let layout = LogGroup("layout")
}

public func warnForNoIdentifier(in constraints: [NSLayoutConstraint]) {
    guard let logger = logger else { return }
    guard logger.isGroupActive(.layout) else { return }
    for constraint in constraints {
        if constraint.identifier == nil {
            logWarning("No identifier for: \(constraint)", group: .layout)
        }
    }
}

public final class Constraints: Invalidatable {
    public private(set) var constraints: [NSLayoutConstraint]
    private let identifier: String?

    @discardableResult public init(activate: Bool = true, identifier: String? = nil, _ constraints: [NSLayoutConstraint]) {
        warnForNoIdentifier(in: constraints)
        self.constraints = constraints
        self.identifier = identifier
        if activate {
            NSLayoutConstraint.activate(constraints)
        }
    }

    @discardableResult public convenience init(activate: Bool = true, identifier: String? = nil, _ constraints: NSLayoutConstraint...) {
        self.init(activate: activate, identifier: identifier, constraints)
    }

    public var first: NSLayoutConstraint! {
        assert(constraints.count == 1, "Attempting to perform single-constraint operation on Constraints not containing exactly one NSLayoutConstrait.")
        return constraints.first
    }

    public var constant: CGFloat {
        get { return first.constant }
        set { first.constant = newValue }
    }
    
    public func append(_ constraints: Constraints) {
        self.constraints.append(contentsOf: constraints.constraints)
    }

    public func replace(with constraints: @autoclosure () -> Constraints) {
        invalidate()
        self.constraints = constraints().constraints
    }

    public func activate() {
        NSLayoutConstraint.activate(constraints)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }

    public func invalidate() {
        deactivate()
        constraints.removeAll()
    }
}
