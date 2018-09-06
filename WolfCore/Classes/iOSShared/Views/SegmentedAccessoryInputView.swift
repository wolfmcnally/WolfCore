//
//  SegmentedAccessoryInputView.swift
//  WolfCore iOS
//
//  Created by Wolf McNally on 1/16/18.
//  Copyright © 2018 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfNesting

public class SegmentedAccessoryInputView: View {
    private lazy var stackView = HorizontalStackView() • { 🍒 in
        🍒.distribution = .fillEqually
    }

    private lazy var backgroundView: UIView = {
        let effect = UIBlurEffect(style: .light)
        let view = ‡UIVisualEffectView(effect: effect)
        return view
    }()

    private class Segment: View {
        private typealias `Self` = Segment

        private static let selectedColor = UIColor(white: 1, alpha: 0.2)
        private static let dividerColor = UIColor(white: 1, alpha: 0.2)

        private let title: String
        private let action: (Segment) -> Void
        var isSelected: Bool = false {
            didSet {
                syncToSelected()
            }
        }

        init(title: String, action: @escaping (Segment) -> Void) {
            self.title = title
            self.action = action
            super.init(frame: .zero)
        }

        override func tintColorDidChange() {
            super.tintColorDidChange()
            button.setTitleColor(tintColor, for: .normal)
            button.setTitleColor(tintColor.withAlphaComponent(0.5), for: .highlighted)
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private var buttonAction: ControlAction<Button>!

        private lazy var button = Button(type: .custom) • { 🍒 in
            🍒.setTitle(title, for: [])
            buttonAction = addTouchUpInsideAction(to: 🍒) { [unowned self] _ in
                self.action(self)
            }
        }

        private lazy var divider = View() • { 🍒 in
            🍒.backgroundColor = Self.dividerColor
            🍒.constrainWidth(to: 0.5)
        }

        override func setup() {
            super.setup()
            self => [
                button,
                divider
            ]

            button.constrainFrameToFrame()

            Constraints(
                divider.heightAnchor == heightAnchor,
                divider.leadingAnchor == trailingAnchor,
                divider.topAnchor == topAnchor
            )
        }

        private func syncToSelected() {
            if isSelected {
                backgroundColor = Self.selectedColor
            } else {
                backgroundColor = .clear
            }
        }
    }

    public override func setup() {
        super.setup()
        translatesAutoresizingMaskIntoConstraints = true
        frame = CGRect(x: 0, y: 0, width: 100, height: 45)

        self => [
            backgroundView,
            stackView
        ]
        backgroundView.constrainFrameToFrame()
        stackView.constrainFrameToFrame()
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
    }

    private weak var selectedSegment: Segment! {
        didSet {
            for segment in self.stackView.arrangedSubviews as! [Segment] {
                segment.isSelected = segment === selectedSegment
            }
        }
    }

    public func addSegment(title: String, action: @escaping Block) {
        func selectSegment(segment: Segment) {
            selectedSegment = segment
            action()
        }

        let segment = Segment(title: title, action: selectSegment)

        stackView => [
            segment
        ]

        if stackView.arrangedSubviews.count == 1 {
            selectSegment(segment: segment)
        }
    }
}
