//
//  BounceButton.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

open class BounceButton: Button {
    @IBInspectable public var waitForBounce: Bool = true
    
    private lazy var bounceAnimation: BounceAnimation = .init(view: self)
    
    open override var isHighlighted: Bool {
        didSet(oldHighlighted) {
            bounceAnimation.animate(oldHighlighted: oldHighlighted, newHighlighted: isHighlighted)
        }
    }
    
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        let waitForBounce = self.waitForBounce
        bounceAnimation.animateRelease() {
            if waitForBounce {
                super.sendAction(action, to: target, for: event)
            }
        }
        if !waitForBounce {
            super.sendAction(action, to: target, for: event)
        }
    }
}
