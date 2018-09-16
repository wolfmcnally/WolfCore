//
//  ScrollingStackView.swift
//  WolfCore
//
//  Created by Robert McNally on 6/30/16.
//  Copyright © 2016 Arciem.
//

import UIKit
import WolfNesting

//  keyboardAvoidantView: KeyboardAvoidantView
//      outerStackView: StackView
//          < your non-scrolling views above the scrolling view >
//          scrollView: ScrollView
//              stackView: StackView
//                  < your views that will scroll if necessary >
//          < your non-scrolling views below the scrolling view >

open class ScrollingStackView: View {
    public private(set) lazy var keyboardAvoidantView = KeyboardAvoidantView()

    public private(set) lazy var outerStackView = StackView() • { 🍒 in
        🍒.axis = .vertical
        🍒.distribution = .fill
        🍒.alignment = .fill
    }

    public private(set) lazy var scrollView = ScrollView() • { 🍒 in
        🍒.indicatorStyle = .white
        🍒.keyboardDismissMode = .interactive
    }

    public private(set) lazy var stackView = StackView() • { 🍒 in
        🍒.axis = .vertical
        🍒.distribution = .fill
        🍒.alignment = .fill
    }

    public var stackViewInsets: UIEdgeInsets = .zero {
        didSet { syncInsets() }
    }

    private var stackViewConstraints = Constraints()

    open override func setup() {
        super.setup()

        self => [
            keyboardAvoidantView => [
                outerStackView => [
                    scrollView => [
                        stackView
                    ]
                ]
            ]
        ]

        Constraints(
            keyboardAvoidantView.leadingAnchor == leadingAnchor,
            keyboardAvoidantView.trailingAnchor == trailingAnchor,
            keyboardAvoidantView.topAnchor == topAnchor,
            keyboardAvoidantView.bottomAnchor == bottomAnchor =&= UILayoutPriority.required - 1
        )

        outerStackView.constrainFrameToFrame()

        syncInsets()
    }

    private func syncInsets() {
        stackViewConstraints ◊= Constraints(
            stackView.leadingAnchor == leadingAnchor + stackViewInsets.left,
            stackView.trailingAnchor == trailingAnchor - stackViewInsets.right,
            stackView.leadingAnchor == scrollView.leadingAnchor + stackViewInsets.left,
            stackView.trailingAnchor == scrollView.trailingAnchor - stackViewInsets.right,
            stackView.topAnchor == scrollView.topAnchor + stackViewInsets.top,
            stackView.bottomAnchor == scrollView.bottomAnchor - stackViewInsets.bottom
        )
    }

    public func flashScrollIndicators() {
        scrollView.flashScrollIndicators()
    }
}
