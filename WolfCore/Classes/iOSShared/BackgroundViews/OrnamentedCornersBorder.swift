//
//  OrnamentedCornersBorder.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/18.
//

import UIKit

public struct OrnamentedCornersBorder: Border {
    private typealias `Self` = OrnamentedCornersBorder

    public var lineWidth: CGFloat
    public var ornaments: CornerOrnaments
    public var fillColor: UIColor?
    public var strokeColor: UIColor?

    public init(lineWidth: CGFloat = 1, ornaments: CornerOrnaments = CornerOrnaments(cornerRadius: 8), fillColor: UIColor? = nil, strokeColor: UIColor? = .black) {
        self.lineWidth = lineWidth
        self.ornaments = ornaments
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }

    private static func clampCornerRadius(_ cornerRadius: CGFloat, in frame: CGRect?) -> CGFloat {
        return RoundedCornersBorder.clampCornerRadius(cornerRadius, in: frame)
    }

    public func makeInsets(in rect: CGRect?) -> UIEdgeInsets {
        // Adjust the sides of the frame to account for the presence of bubble tails
        var insets = UIEdgeInsets.zero

        func adjustTopLeft(_ i: UIEdgeInsets) {
            insets.top = max(insets.top, i.top)
            insets.left = max(insets.left, i.left)
        }

        func adjustBottomLeft(_ i: UIEdgeInsets) {
            insets.bottom = max(insets.bottom, i.bottom)
            insets.left = max(insets.left, i.left)
        }

        func adjustBottomRight(_ i: UIEdgeInsets) {
            insets.bottom = max(insets.bottom, i.bottom)
            insets.right = max(insets.right, i.right)
        }

        func adjustTopRight(_ i: UIEdgeInsets) {
            insets.top = max(insets.top, i.top)
            insets.right = max(insets.right, i.right)
        }

        switch ornaments.topLeft {
        case .square:
            adjustTopLeft(RectBorder(lineWidth: lineWidth).makeInsets(in: rect))
        case .rounded(let cornerRadius):
            adjustTopLeft(RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makeInsets(in: rect))
        case .bubbleTail:
            preconditionFailure("not supported")
        }

        switch ornaments.bottomLeft {
        case .square:
            adjustBottomLeft(RectBorder(lineWidth: lineWidth).makeInsets(in: rect))
        case .rounded(let cornerRadius):
            adjustBottomLeft(RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makeInsets(in: rect))
        case .bubbleTail(let cornerRadius):
            let smallRadius = cornerRadius / 2
            var i = RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makeInsets(in: rect)
            i.left += smallRadius
            adjustBottomLeft(i)
        }

        switch ornaments.bottomRight {
        case .square:
            adjustBottomRight(RectBorder(lineWidth: lineWidth).makeInsets(in: rect))
        case .rounded(let cornerRadius):
            adjustBottomRight(RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makeInsets(in: rect))
        case .bubbleTail(let cornerRadius):
            let smallRadius = cornerRadius / 2
            var i = RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makeInsets(in: rect)
            i.right += smallRadius
            adjustBottomRight(i)
        }

        switch ornaments.topRight {
        case .square:
            adjustTopRight(RectBorder(lineWidth: lineWidth).makeInsets(in: rect))
        case .rounded(let cornerRadius):
            adjustTopRight(RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makeInsets(in: rect))
        case .bubbleTail:
            preconditionFailure("not supported")
        }

        return insets
    }

    public func makePath(in frame: CGRect) -> UIBezierPath {
        let halfLineWidth = lineWidth / 2

        // If we're simply drawing a rectangular path, then do it in one step.
        guard !ornaments.isAllSquare else { return RectBorder(lineWidth: lineWidth).makePath(in: frame) }

        // If we're simply drawing a rounded-corner path with all the same radii, then do it in one step.
        if let cornerRadius = ornaments.allRoundedRadius() {
            return RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius).makePath(in: frame)
        }

        // `frame` is the given rectangle adjusted for the line width and any ornaments
        var frameInsets = /*makeInsets(in: frame) + */ UIEdgeInsets(all: lineWidth / 2)

        if case let .bubbleTail(cornerRadius) = ornaments.bottomLeft {
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame)
            let smallRadius = cornerRadius / 2
            frameInsets.left += smallRadius - halfLineWidth
        }
        if case let .bubbleTail(cornerRadius) = ornaments.bottomRight {
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame)
            let smallRadius = cornerRadius / 2
            frameInsets.right += smallRadius - halfLineWidth
        }

        // Apply the frame insets
        let frame = frame.inset(by: frameInsets)

        let path = UIBezierPath()
        path.lineWidth = lineWidth

        func addSquareCorner(at point: CGPoint, isFirst: Bool = false) {
            if isFirst {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        func addRoundedCorner(at center: CGPoint, cornerRadius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
            path.addArc(withCenter: center, radius: cornerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        }

        let a: CGFloat = 26.2°
        let b: CGFloat = 36°

        func addBottomRightBubbleTailCorner(cornerRadius: CGFloat) {
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame)
            let center = frame.maxXmaxY + CGVector(dx: -cornerRadius, dy: -cornerRadius)
            let smallRadius = cornerRadius / 2
            let center2 = CGPoint(x: center.x + cornerRadius + smallRadius, y: center.y - cornerRadius)
            let center3 = CGPoint(x: center.x + cornerRadius + smallRadius, y: center.y + smallRadius)
            path.addArc(withCenter: center3, radius: smallRadius, startAngle: 180°, endAngle: 90°, clockwise: false)
            path.addArc(withCenter: center2, radius: cornerRadius * 2, startAngle: 90°, endAngle: 90° + a, clockwise: true)
            path.addArc(withCenter: center, radius: cornerRadius, startAngle: 90° - b, endAngle: 90°, clockwise: true)

        }

        func addBottomLeftBubbleTailCorner(cornerRadius: CGFloat) {
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame)
            let center = frame.minXmaxY + CGVector(dx: cornerRadius, dy: -cornerRadius)
            let smallRadius = cornerRadius / 2
            let center2 = CGPoint(x: center.x - cornerRadius - smallRadius, y: center.y - cornerRadius)
            let center3 = CGPoint(x: center.x - cornerRadius - smallRadius, y: center.y + smallRadius)
            path.addArc(withCenter: center, radius: cornerRadius, startAngle: 90°, endAngle: 90° + b, clockwise: true)
            path.addArc(withCenter: center2, radius: cornerRadius * 2, startAngle: 90° - a, endAngle: 90°, clockwise: true)
            path.addArc(withCenter: center3, radius: smallRadius, startAngle: 90°, endAngle: 0°, clockwise: false)
        }

        switch ornaments.bottomRight {
        case .square:
            addSquareCorner(at: frame.maxXmaxY, isFirst: true)
        case .rounded(let cornerRadius):
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame) - halfLineWidth
            let center = frame.maxXmaxY + CGVector(dx: -cornerRadius, dy: -cornerRadius)
            addRoundedCorner(at: center, cornerRadius: cornerRadius, startAngle: 0°, endAngle: 90°)
        case .bubbleTail(let cornerRadius):
            addBottomRightBubbleTailCorner(cornerRadius: cornerRadius)
        }

        switch ornaments.bottomLeft {
        case .square:
            addSquareCorner(at: frame.minXmaxY)
        case .rounded(let cornerRadius):
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame) - halfLineWidth
            let center = frame.minXmaxY + CGVector(dx: cornerRadius, dy: -cornerRadius)
            addRoundedCorner(at: center, cornerRadius: cornerRadius, startAngle: 90°, endAngle: 180°)
        case .bubbleTail(let cornerRadius):
            addBottomLeftBubbleTailCorner(cornerRadius: cornerRadius)
        }

        switch ornaments.topLeft {
        case .square:
            addSquareCorner(at: frame.minXminY)
        case .rounded(let cornerRadius):
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame) - halfLineWidth
            let center = frame.minXminY + CGVector(dx: cornerRadius, dy: cornerRadius)
            addRoundedCorner(at: center, cornerRadius: cornerRadius, startAngle: 180°, endAngle: 270°)
        case .bubbleTail:
            preconditionFailure("not supported")
        }

        switch ornaments.topRight {
        case .square:
            addSquareCorner(at: frame.maxXminY)
        case .rounded(let cornerRadius):
            let cornerRadius = Self.clampCornerRadius(cornerRadius, in: frame) - halfLineWidth
            let center = frame.maxXminY + CGVector(dx: -cornerRadius, dy: cornerRadius)
            addRoundedCorner(at: center, cornerRadius: cornerRadius, startAngle: 270°, endAngle: 360°)
        case .bubbleTail:
            preconditionFailure("not supported")
        }

        path.close()

        return path
    }
}
