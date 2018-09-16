//
//  ActivityIndicatorView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com.
//

import UIKit
import WolfNesting

public class ActivityIndicatorView: View {
    private let style: UIActivityIndicatorView.Style
    private var hysteresis: Hysteresis!

    public init(activityIndicatorStyle style: UIActivityIndicatorView.Style = .white) {
        self.style = style

        super.init(frame: .zero)

        hysteresis = Hysteresis(
            onStart: {
                self.activityIndicatorView.show(animated: true)
        },
            onEnd: {
                self.activityIndicatorView.hide(animated: true)
        },
            startLag: 0.25,
            endLag: 0.2
        )
    }

    private func revealIndicator(animated: Bool) {
        activityIndicatorView.show(animated: animated)
    }

    private func concealIndicator(animated: Bool) {
        activityIndicatorView.hide(animated: animated)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func newActivity() -> LockerCause {
        return hysteresis.newCause()
    }

    private lazy var activityIndicatorView = UIActivityIndicatorView(style: self.style) • { 🍒 in
        ‡🍒
        🍒.hidesWhenStopped = false
        🍒.startAnimating()
    }

    override public func setup() {
        super.setup()

        setPriority(crH: .defaultLow, crV: .defaultLow)

        self => [
            activityIndicatorView
        ]

        activityIndicatorView.constrainCenterToCenter()
        Constraints(
            widthAnchor == activityIndicatorView.widthAnchor =&= .defaultLow,
            heightAnchor == activityIndicatorView.heightAnchor =&= .defaultLow,
            widthAnchor == heightAnchor
        )

        concealIndicator(animated: false)
    }
}
