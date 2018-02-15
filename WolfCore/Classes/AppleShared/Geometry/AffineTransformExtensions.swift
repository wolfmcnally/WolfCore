//
//  AffineTransformExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreGraphics

extension CGAffineTransform {
    public init(scaling s: CGVector) {
        self.init(scaleX: s.dx, y: s.dy)
    }

    public init(translation t: CGVector) {
        self.init(translationX: t.dx, y: t.dy)
    }

    public func scaled(by v: CGVector) -> CGAffineTransform {
        return scaledBy(x: v.dx, y: v.dy)
    }

    public func translated(by v: CGVector) -> CGAffineTransform {
        return translatedBy(x: v.dx, y: v.dy)
    }

    public func rotated(by angle: CGFloat, around point: CGPoint) -> CGAffineTransform {
        return translatedBy(x: point.x, y: point.y).rotated(by: angle).translatedBy(x: -point.x, y: -point.y)
    }
}
