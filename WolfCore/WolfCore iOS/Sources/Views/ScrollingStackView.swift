//
//  ScrollingStackView.swift
//  WolfCore
//
//  Created by Robert McNally on 6/30/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import UIKit
import WolfBase

//  keyboardAvoidantView: KeyboardAvoidantView
//      outerStackView: StackView
//          < your non-scrolling views above the scrolling view >
//          scrollView: ScrollView
//              stackView: StackView
//                  < your views that will scroll if necessary >
//          < your non-scrolling views below the scrolling view >

open class ScrollingStackView: View {
    public private(set) lazy var keyboardAvoidantView: KeyboardAvoidantView = .init()

    public private(set) lazy var outerStackView: StackView = .init() • { 🍒 in
        🍒.axis = .vertical
        🍒.distribution = .fill
        🍒.alignment = .fill
    }

    public private(set) lazy var scrollView: ScrollView = .init() • { 🍒 in
        🍒.indicatorStyle = .white
        🍒.keyboardDismissMode = .interactive
    }

    public private(set) lazy var stackView: StackView = .init() • { 🍒 in
        🍒.axis = .vertical
        🍒.distribution = .fill
        🍒.alignment = .fill
    }

    open override func setup() {
        super.setup()
        setupKeyboardAvoidantView()
        setupOuterStackView()
        setupScrollView()
        setupStackView()
    }

    public func flashScrollIndicators() {
        scrollView.flashScrollIndicators()
    }

    private func setupKeyboardAvoidantView() {
        addSubview(keyboardAvoidantView)
        Constraints(
            keyboardAvoidantView.leadingAnchor == leadingAnchor,
            keyboardAvoidantView.trailingAnchor == trailingAnchor,
            keyboardAvoidantView.topAnchor == topAnchor,
            keyboardAvoidantView.bottomAnchor == bottomAnchor =&= UILayoutPriority.required - 1
        )
    }

    private func setupOuterStackView() {
        keyboardAvoidantView.addSubview(outerStackView)
        outerStackView.constrainFrameToFrame()
    }

    private func setupScrollView() {
        outerStackView.addArrangedSubview(scrollView)
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        Constraints(
            stackView.leadingAnchor == leadingAnchor,
            stackView.trailingAnchor == trailingAnchor,

            stackView.leadingAnchor == scrollView.leadingAnchor,
            stackView.trailingAnchor == scrollView.trailingAnchor,
            stackView.topAnchor == scrollView.topAnchor,
            stackView.bottomAnchor == scrollView.bottomAnchor
        )
    }
}
