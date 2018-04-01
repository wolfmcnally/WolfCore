//
//  BordersTestView.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/1/18.
//

import UIKit

public class BordersTestView: View {
    public override func setup() {
        contentMode = .redraw
        backgroundColor = debugColor(when: true, debug: .gray)
        constrainSize(to: CGSize(width: 300, height: 300))
    }

    public override func draw(_ rect: CGRect) {
        let lineWidth: CGFloat = 10
        let strokeColor = UIColor.red.withAlphaComponent(0.5)
        let fillColor = UIColor.blue.withAlphaComponent(0.5)
        var bounds = self.bounds

        func paint(border: Border, in rect: CGRect) {
            border.draw(in: rect)

            let rectPath = UIBezierPath(rect: rect)
            rectPath.lineWidth = 0.5
            UIColor.green.setStroke()
            rectPath.stroke()

            let insetRect = UIEdgeInsetsInsetRect(rect, border.makeInsets(in: rect))
            let path = UIBezierPath(rect: insetRect)
            path.lineWidth = 0.5
            UIColor.white.setStroke()
            path.stroke()
        }

        do {
            let border = RectBorder(lineWidth: lineWidth, fillColor: fillColor, strokeColor: strokeColor)
            paint(border: border, in: bounds)
        }

        bounds = bounds.insetBy(dx: 30, dy: 30)
        do {
            let border = RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: 30, fillColor: fillColor, strokeColor: strokeColor)
            paint(border: border, in: bounds)
        }

        bounds = bounds.insetBy(dx: 30, dy: 30)
        do {
            let ornaments = CornerOrnaments(topLeft: .square, bottomLeft: .bubbleTail(cornerRadius: 20), bottomRight: .bubbleTail(cornerRadius: 20), topRight: .rounded(cornerRadius: 30))
            let border = OrnamentedCornersBorder(lineWidth: lineWidth, ornaments: ornaments, fillColor: fillColor, strokeColor: strokeColor)
            paint(border: border, in: bounds)
        }
    }
}
