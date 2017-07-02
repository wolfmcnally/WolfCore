//
//  NavigationBarBlurEffect.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

class NavigationBarBlurEffect {
  weak var navigationController: NavigationController!
  
  private var effectView: UIVisualEffectView!
  private var topConstraint: NSLayoutConstraint!
  
  required init(navigationController: NavigationController) {
    self.navigationController = navigationController
    setup()
  }
  
  func setup() {
    let effect = UIBlurEffect(style: .light)
    effectView = ~UIVisualEffectView(effect: effect)
    // Add the effect view as a the first subview of the _UIBarBackground view
    let navigationBar = navigationController.navigationBar
    navigationBar.subviews[0].insertSubview(effectView, at: 0)
    navigationBar.backgroundColor = .clear
    topConstraint = effectView.topAnchor == navigationBar.topAnchor
    Constraints(
      effectView.leftAnchor == navigationBar.leftAnchor,
      effectView.rightAnchor == navigationBar.rightAnchor,
      effectView.bottomAnchor == navigationBar.bottomAnchor,
      topConstraint
    )
  }
  
  func update() {
    var statusBarAdjustment: CGFloat = -20
    out: do {
      guard navigationController.traitCollection.horizontalSizeClass == .regular else { break out }
      guard navigationController.modalPresentationStyle == .fullScreen else { break out }
      guard navigationController.presentingViewController != nil else { break out }
      guard !navigationController.modalPresentationCapturesStatusBarAppearance else { break out }
      statusBarAdjustment = 0
    }
    topConstraint.constant = statusBarAdjustment
  }
  
  //    func invalidate() {
  //        effectView.removeFromSuperview()
  //    }
  
  func show() {
    effectView.show()
  }
  
  func hide() {
    effectView.hide()
  }
}
