//
//  BorderBackgroundView
//  WolfCore
//
//  Created by Wolf McNally on 5/4/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

open class BorderBackgroundView: BackgroundView {
    public var border: Border {
        didSet { setNeedsDisplay() }
    }

    public init(border: Border = RectBorder()) {
        self.border = border
        super.init(frame: .zero)
        contentMode = .redraw
    }

    open override var insets: UIEdgeInsets {
        return border.insets
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func draw(_ rect: CGRect) {
        border.draw(in: bounds)
    }
}
