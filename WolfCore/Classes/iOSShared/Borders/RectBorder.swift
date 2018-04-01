//
//  RectBorder.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/18.
//

import UIKit

public struct RectBorder: Border {
    public var lineWidth: CGFloat
    public var fillColor: UIColor?
    public var strokeColor: UIColor?

    public init(lineWidth: CGFloat = 1, fillColor: UIColor? = nil, strokeColor: UIColor? = nil) {
        self.lineWidth = lineWidth
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }

    public func makePath(in frame: CGRect) -> UIBezierPath {
        let halfLineWidth = lineWidth / 2
        let insetRect = frame.insetBy(dx: halfLineWidth, dy: halfLineWidth)
        let path = UIBezierPath(rect: insetRect)
        path.lineWidth = lineWidth
        return path
    }

    public func makeInsets(in frame: CGRect?) -> UIEdgeInsets {
        return UIEdgeInsets(all: lineWidth)
    }
}
