//
//  BorderView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/4/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class BorderView: View {
    public var border: Border {
        didSet { setNeedsDisplay() }
    }

    public init(border: Border = RectBorder()) {
        self.border = border
        super.init(frame: .zero)
        contentMode = .redraw
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        border.draw(in: bounds)
    }
}
