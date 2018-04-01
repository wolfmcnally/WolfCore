//
//  CornerOrnaments.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/18.
//

import CoreGraphics

public struct CornerOrnaments {
    public enum Ornament {
        case square
        case rounded(cornerRadius: CGFloat)
        case bubbleTail(cornerRadius: CGFloat)
    }

    public var topLeft: Ornament
    public var bottomLeft: Ornament
    public var bottomRight: Ornament
    public var topRight: Ornament

    public init(topLeft: Ornament, bottomLeft: Ornament, bottomRight: Ornament, topRight: Ornament) {
        self.topLeft = topLeft
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
        self.topRight = topRight
    }

    public init() {
        self.init(topLeft: .square, bottomLeft: .square, bottomRight: .square, topRight: .square)
    }

    public init(cornerRadius: CGFloat) {
        self.init(topLeft: .rounded(cornerRadius: cornerRadius), bottomLeft: .rounded(cornerRadius: cornerRadius), bottomRight: .rounded(cornerRadius: cornerRadius), topRight: .rounded(cornerRadius: cornerRadius))
    }

    public var isAllSquare: Bool {
        guard case .square = topLeft else { return false }
        guard case .square = bottomLeft else { return false }
        guard case .square = bottomRight else { return false }
        guard case .square = topRight else { return false }
        return true
    }

    public func allRoundedRadius() -> CGFloat? {
        guard case let .rounded(topLeftRadius) = topLeft else { return nil }
        guard case let .rounded(bottomLeftRadius) = bottomLeft else { return nil }
        guard case let .rounded(bottomRightRadius) = bottomRight else { return nil }
        guard case let .rounded(topRightRadius) = topRight else { return nil }
        guard topLeftRadius == bottomLeftRadius else { return nil }
        guard topLeftRadius == bottomRightRadius else { return nil }
        guard topLeftRadius == topRightRadius else { return nil }
        return topLeftRadius
    }
}
