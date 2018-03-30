//
//  DividerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/8/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class DividerView: View {
    public typealias `Self` = DividerView

    public enum Position {
        case top
        case bottom
    }

    private let position: Position
    private let lineWidth: CGFloat

    public static let defaultColor = UIColor(white: 0, alpha: 0.1)

    public init(position: Position = .bottom, color: UIColor = Self.defaultColor, lineWidth: CGFloat = 0.5) {
        self.position = position
        self.lineWidth = lineWidth
        super.init(frame: .zero)
        backgroundColor = color
    }

    required public init?(coder aDecoder: NSCoder) {
        self.position = .bottom
        self.lineWidth = 0.5
        super.init(coder: aDecoder)
        backgroundColor = .white
    }

    public override func setup() {
        super.setup()
        constrainHeight(to: lineWidth)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            Constraints(
                widthAnchor == superview.widthAnchor,
                centerXAnchor == superview.centerXAnchor
            )
            switch position {
            case .top:
                Constraints(topAnchor == superview.topAnchor)
            case .bottom:
                Constraints(bottomAnchor == superview.bottomAnchor)
            }
        }
    }
}
