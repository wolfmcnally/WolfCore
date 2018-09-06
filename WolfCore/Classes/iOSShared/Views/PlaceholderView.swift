//
//  PlaceholderView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfNesting

open class PlaceholderView: View {
    public var color: UIColor? { didSet { setNeedsDisplay() } }
    public var lineWidth: CGFloat { didSet { setNeedsDisplay() } }
    
    public private(set) var titleLabel = Label() • { 🍒 in
        🍒.font = .systemFont(ofSize: 12)
        🍒.textColor = .darkGray
        🍒.adjustsFontSizeToFitWidth = true
        🍒.minimumScaleFactor = 0.2
        🍒.baselineAdjustment = .alignCenters
        🍒.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    @IBInspectable public var title: String! {
        didSet {
            syncTitle()
        }
    }

    private func syncTitle() {
        titleLabel.text = title
    }

    public init(title: String? = nil, backgroundColor: UIColor? = nil, lineWidth: CGFloat = 1, color: UIColor? = nil) {
        self.lineWidth = lineWidth
        self.color = color
        super.init(frame: .zero)
        self.title = title
        self.backgroundColor = backgroundColor
        syncTitle()
    }

    public required init?(coder aDecoder: NSCoder) {
        lineWidth = 1
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        syncTitle()
    }

    open override func setup() {
        super.setup()
        contentMode = .redraw
        self => [
            titleLabel
        ]
        titleLabel.constrainCenterToCenter()
        Constraints(
            titleLabel.widthAnchor <= widthAnchor
        )
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPlaceholderRect(rect, lineWidth: lineWidth, color: color)
    }
}
