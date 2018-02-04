//
//  AutolayoutOperators.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/3/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public func + (left: NSLayoutXAxisAnchor, right: CGFloat) -> (anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
    return (left, right)
}

public func + (left: NSLayoutYAxisAnchor, right: CGFloat) -> (anchor: NSLayoutYAxisAnchor, constant: CGFloat) {
    return (left, right)
}

public func + (left: NSLayoutDimension, right: CGFloat) -> (anchor: NSLayoutDimension, constant: CGFloat) {
    return (left, right)
}


public func - (left: NSLayoutXAxisAnchor, right: CGFloat) -> (anchor: NSLayoutXAxisAnchor, constant: CGFloat) {
    return (left, -right)
}

public func - (left: NSLayoutYAxisAnchor, right: CGFloat) -> (anchor: NSLayoutYAxisAnchor, constant: CGFloat) {
    return (left, -right)
}

public func - (left: NSLayoutDimension, right: CGFloat) -> (anchor: NSLayoutDimension, constant: CGFloat) {
    return (left, -right)
}


public func * (left: NSLayoutDimension, right: CGFloat) -> (anchor: NSLayoutDimension, multiplier: CGFloat) {
    return (left, right)
}

public func + (left: (anchor: NSLayoutDimension, multiplier: CGFloat), right: CGFloat) -> (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat) {
    return (anchor: left.anchor, multiplier: left.multiplier, constant: right)
}


public func == (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(equalTo: right)
}

public func == (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(equalTo: right)
}

public func == (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
    return left.constraint(equalTo: right)
}


public func == (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, constant: right.constant)
}

public func == (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, constant: right.constant)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, constant: right.constant)
}


public func == (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraint(equalToConstant: right)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, multiplier: right.multiplier)
}

public func == (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(equalTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func >= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right)
}

public func >= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right)
}

public func >= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right)
}


public func >= (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant)
}

public func >= (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, constant: right.constant)
}


public func >= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualToConstant: right)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, multiplier: right.multiplier)
}

public func >= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(greaterThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
}


public func <= (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right)
}

public func <= (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right)
}

public func <= (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right)
}


public func <= (left: NSLayoutXAxisAnchor, right: (anchor: NSLayoutXAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant)
}

public func <= (left: NSLayoutYAxisAnchor, right: (anchor: NSLayoutYAxisAnchor, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, constant: right.constant)
}


public func <= (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualToConstant: right)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, multiplier: right.multiplier)
}

public func <= (left: NSLayoutDimension, right: (anchor: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat)) -> NSLayoutConstraint {
    return left.constraint(lessThanOrEqualTo: right.anchor, multiplier: right.multiplier, constant: right.constant)
}

public func =&= (left: NSLayoutConstraint, right: LayoutPriority) -> NSLayoutConstraint {
    left.priority = right
    return left
}

public func =%= (left: NSLayoutConstraint, right: String) -> NSLayoutConstraint {
    left.identifier = right
    return left
}

public func =%= (left: NSLayoutConstraint, right: [Any?]) -> NSLayoutConstraint {
    let filtered = right.reduce ([String]()) { (accum, elem) in
        var accum = accum
        if let elem = elem {
            accum.append("\(elem)")
        }
        return accum
    }
    return left =%= filtered.joined(separator: "-")
}
