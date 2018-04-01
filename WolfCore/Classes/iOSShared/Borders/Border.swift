//
//  PathUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/31/18.
//

import UIKit

public protocol Border {
    var lineWidth: CGFloat { get set }
    var fillColor: UIColor? { get set }
    var strokeColor: UIColor? { get set }

    func makePath(in frame: CGRect) -> UIBezierPath
    func makeInsets(in frame: CGRect?) -> UIEdgeInsets

    func makeInsets() -> UIEdgeInsets

    func draw(in frame: CGRect)
}

extension Border {
    public func makeInsets() -> UIEdgeInsets {
        return makeInsets(in: nil)
    }
    
    public func draw(in frame: CGRect) {
        let path = makePath(in: frame)
        if let fillColor = fillColor {
            fillColor.setFill()
            path.fill()
        }
        if let strokeColor = strokeColor {
            strokeColor.setStroke()
            path.lineWidth = lineWidth
            path.stroke()
        }
    }
}
