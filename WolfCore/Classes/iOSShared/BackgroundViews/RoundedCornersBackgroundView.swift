//
//  RoundedCornersBackgroundView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/7/18.
//

import UIKit

open class RoundedCornersBackgroundView: BorderBackgroundView {
    public init(lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8, fillColor: UIColor? = nil, strokeColor: UIColor? = .black) {
        let border = RoundedCornersBorder(lineWidth: lineWidth, cornerRadius: cornerRadius, fillColor: fillColor, strokeColor: strokeColor)
        super.init(border: border)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
