//
//  Insets.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/16/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public struct Insets<T: BinaryFloatingPoint> {
    public var top: T?
    public var left: T?
    public var bottom: T?
    public var right: T?

    public init(top: T? = nil, left: T? = nil, bottom: T? = nil, right: T? = nil) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    public init(all n: T) {
        self.init(top: n, left: n, bottom: n, right: n)
    }

    public init(size: T) {
        self.init(top: size, left: size, bottom: size, right: size)
    }

    public init(horizontal h: T, vertical v: T) {
        self.init(top: v, left: h, bottom: v, right: h)
    }

    public static var zero: Insets { return Insets(top: 0, left: 0, bottom: 0, right: 0) }

    public var horizontal: T {
        return (left ?? 0) + (right ?? 0)
    }

    public var vertical: T {
        return (top ?? 0) + (bottom ?? 0)
    }
}

#if canImport(CoreGraphics)
    import CoreGraphics

    public typealias CGInsets = Insets<CGFloat>
#endif

#if canImport(UIKit)
    import UIKit

    extension Insets where T == CGFloat {
        public init(edgeInsets e: UIEdgeInsets) {
            self.init(top: e.top, left: e.left, bottom: e.bottom, right: e.right)
        }
    }

    extension UIEdgeInsets {
        public init(all n: CGFloat) {
            self.init(top: n, left: n, bottom: n, right: n)
        }

        public init(horizontal h: CGFloat, vertical v: CGFloat) {
            self.init(top: v, left: h, bottom: v, right: h)
        }

        public var horizontal: CGFloat {
            return left + right
        }

        public var vertical: CGFloat {
            return top + bottom
        }
    }

    public func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }

    #if swift(>=4.2)
    // Workaround for https://bugs.swift.org/browse/SR-7879
    extension UIEdgeInsets {
        static let zero = UIEdgeInsets()
    }
    #endif
#endif
