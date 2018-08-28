//
//  ActivityOverlayView.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/12/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class ActivityOverlayView: View {
    public private(set) var hysteresis: Hysteresis!

    @objc dynamic public var color = UIColor.black.withAlphaComponent(0.5)

    public init(startLag: TimeInterval = 0.5, endLag: TimeInterval = 0.4) {
        super.init(frame: .zero)
        hysteresis = Hysteresis(
            onStart: {
                self.show(animated: true)
        },
            onEnd: {
                self.hide(animated: true)
        },
            startLag: startLag,
            endLag: endLag
        )
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func newActivity() -> LockerCause {
        return hysteresis.newCause()
    }

    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge) • { 🍒 in
        ‡🍒
        🍒.hidesWhenStopped = false
    }

    public override var isHidden: Bool {
        didSet {
            if isHidden {
                activityIndicatorView.stopAnimating()
            } else {
                activityIndicatorView.startAnimating()
            }
        }
    }

    private lazy var frameView = View() • { 🍒 in
        🍒.constrainSize(to: CGSize(width: 80, height: 80))
        🍒.layer.masksToBounds = true
        🍒.layer.cornerRadius = 10
    }

    override public func setup() {
        super.setup()

        self => [
            frameView => [
                activityIndicatorView
            ]
        ]

        activityIndicatorView.constrainCenterToCenter()
        frameView.constrainCenterToCenter()
        hide()
    }

    public func show(animated: Bool) {
        superview?.bringSubviewToFront(self)
        backgroundColor = color
        super.show(animated: animated)
    }
}
