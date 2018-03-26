//
//  PlaceholderView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

open class PlaceholderView: View {
    public private(set) var titleLabel = Label()

    @IBInspectable public var title: String! {
        didSet {
            syncTitle()
        }
    }

    private func syncTitle() {
        titleLabel.text = title
    }

    public init(title: String? = nil, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.title = title
        self.backgroundColor = backgroundColor
        syncTitle()
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
