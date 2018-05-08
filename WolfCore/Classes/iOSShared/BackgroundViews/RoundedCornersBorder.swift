//
//  RoundedCornersBorder.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/18.
//

import UIKit

public struct RoundedCornersBorder: Border {
    private typealias `Self` = RoundedCornersBorder

    public var lineWidth: CGFloat
    public var cornerRadius: CGFloat
    public var fillColor: UIColor?
    public var strokeColor: UIColor?

    public init(lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8, fillColor: UIColor? = nil, strokeColor: UIColor? = .black) {
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }

    public static func clampCornerRadius(_ cornerRadius: CGFloat, in frame: CGRect?) -> CGFloat {
        guard let frame = frame else { return cornerRadius }
        let minDimension = min(frame.width, frame.height)
        return min(cornerRadius, minDimension / 2)
    }

    public static func makeInsets(for cornerRadius: CGFloat, lineWidth: CGFloat) -> UIEdgeInsets {
        let inset = cornerRadius - cos(45°) * cornerRadius + cos(45°) * lineWidth
        return UIEdgeInsets(all: inset)
    }

    private var effectiveLineWidth: CGFloat {
        return strokeColor != nil ? lineWidth : 0
    }

    public func makePath(in frame: CGRect) -> UIBezierPath {
        let halfLineWidth = effectiveLineWidth / 2
        let clampedCornerRadius = Self.clampCornerRadius(cornerRadius, in: frame) - halfLineWidth
        let insetRect = frame.insetBy(dx: halfLineWidth, dy: halfLineWidth)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: clampedCornerRadius)
        path.lineWidth = effectiveLineWidth
        return path
    }

    public func makeInsets(in frame: CGRect?) -> UIEdgeInsets {
        return Self.makeInsets(for: cornerRadius, lineWidth: effectiveLineWidth)
    }
}
