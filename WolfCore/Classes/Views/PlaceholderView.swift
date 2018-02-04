//
//  PlaceholderView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

open class PlaceholderView: View {
    public private(set) var titleLabel: Label = {
        let label = Label()
        label.text = "Title"
        return label
    }()

    public private(set) lazy var gestureActions: ViewGestureActions = {
        return ViewGestureActions(view: self)
    }()

    private var heightConstraint = Constraints()

    @IBInspectable public var title: String! {
        didSet {
            syncTitle()
        }
    }

    public var height: CGFloat? {
        didSet {
            syncHeight()
        }
    }

    private func syncTitle() {
        titleLabel.text = title
    }

    open override func updateConstraints() {
        super.updateConstraints()
        if let height = height {
            heightConstraint.replace(with: Constraints(heightAnchor == height =&= .defaultHigh))
        } else {
            heightConstraint.invalidate()
        }
    }

    private func syncHeight() {
        setNeedsUpdateConstraints()
    }

    public init(title: String, height: CGFloat? = nil, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.title = title
        self.height = height
        self.backgroundColor = backgroundColor
        syncTitle()
        syncHeight()
    }

    public required init?(coder aDecoder: NSCoder) {
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
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawPlaceholderRect(rect)
    }
}
