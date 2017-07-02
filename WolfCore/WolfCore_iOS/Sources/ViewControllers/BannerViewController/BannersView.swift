//
//  BannersView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

class BannersView: View {
  private var bulletinViews = [BulletinViewProtocol]()
  private var heightConstraint: NSLayoutConstraint!

  private var stackView: VerticalStackView = {
    let view = VerticalStackView()
    return view
  }()

  override func setup() {
    super.setup()

    clipsToBounds = true

    self => [
      stackView
    ]

    Constraints(
      stackView.leadingAnchor == leadingAnchor,
      stackView.trailingAnchor == trailingAnchor,
      stackView.bottomAnchor == bottomAnchor
    )
  }

  private func index(of bulletin: Bulletin) -> Int? {
    return bulletinViews.index { return $0.bulletin === bulletin }
  }

  func addBulletinView(_ bulletinView: BulletinViewProtocol, animated: Bool, animations: @escaping Block) {
    let bulletin = bulletinView.bulletin
    let view = bulletinView.view

    assert(view.superview == nil)

    bulletinViews.append(bulletinView)
    bulletinViews.sort { $0.bulletin.priority == $1.bulletin.priority ? $0.bulletin.date < $1.bulletin.date : $0.bulletin.priority < $1.bulletin.priority }

    let viewIndex = index(of: bulletin)!

    stackView.insertArrangedSubview(view, at: viewIndex)
    stackView.layoutIfNeeded()
    let bottomOffset = stackView.frame.height - view.frame.maxY
    view.removeFromSuperview()

    stackView.insertSubview(view, at: 0)
    Constraints(
      view.leadingAnchor == stackView.leadingAnchor,
      view.trailingAnchor == stackView.trailingAnchor,
      view.bottomAnchor == stackView.bottomAnchor - bottomOffset
    )
    stackView.layoutIfNeeded()
    view.removeFromSuperview()
    
    stackView.insertArrangedSubview(view, at: viewIndex)
    view.alpha = 0
    dispatchAnimated(animated, options: [.allowUserInteraction, .beginFromCurrentState]) {
      view.alpha = 1
      animations()
      }.run()
  }

  func removeView(for bulletin: Bulletin, animated: Bool, animations: @escaping Block) {
    guard let viewIndex = index(of: bulletin) else { return }
    let bulletinView = bulletinViews[viewIndex]
    let view = bulletinView.view
    view.removeFromSuperview()
    stackView.insertSubview(view, at: 0)
    Constraints(
      view.leadingAnchor == stackView.leadingAnchor,
      view.trailingAnchor == stackView.trailingAnchor,
      view.bottomAnchor == stackView.bottomAnchor - (stackView.frame.height - view.frame.maxY)
    )
    bulletinViews.remove(at: viewIndex)
    dispatchAnimated(animated, options: [.allowUserInteraction, .beginFromCurrentState]) {
      view.alpha = 0
      animations()
      }.then { _ in
        view.removeFromSuperview()
      }.run()
  }

  func heightForBanners(count: Int) -> CGFloat {
    var height: CGFloat = 0
    for (viewIndex, bulletinView) in bulletinViews.reversed().enumerated() {
      guard viewIndex < count else { break }
      height += bulletinView.view.frame.height
    }
    return height
  }
}
