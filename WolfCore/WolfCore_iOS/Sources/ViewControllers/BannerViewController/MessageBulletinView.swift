//
//  MessageBulletinView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class MessageBulletinView<B: MessageBulletin>: BulletinView<B> {
  private lazy var contentView: View = .init() • { 🍒 in
    🍒.layer.cornerRadius = 4
    🍒.clipsToBounds = true
  }

  private lazy var stackView: VerticalStackView = .init() • { 🍒 in
    🍒.distribution = .fill
    🍒.alignment = .fill
  }

  private lazy var titleLabel: Label = .init() • { 🍒 in
    🍒.numberOfLines = 1
    🍒.textAlignment = .left
  }

  private lazy var messageLabel: Label = .init() • { 🍒 in
    🍒.numberOfLines = 0
    🍒.textAlignment = .left
  }

  public override func setup() {
    super.setup()

    setupContentView()
    setupStackView()
    setupTitle()
    setupMessage()
  }

  private func setupContentView() {
    self => [
      contentView
    ]

    contentView.constrainFrameToFrame(insets: Insets(top: 2, left: 2, bottom: 2, right: 2))
  }

  private func setupStackView() {
    contentView => [
      stackView
    ]

    Constraints(
      stackView.centerYAnchor == contentView.centerYAnchor,
      stackView.heightAnchor == contentView.heightAnchor - 16,
      stackView.leadingAnchor == contentView.leadingAnchor + 20,
      stackView.trailingAnchor == contentView.trailingAnchor - 20
    )
  }

  public override func didMoveToSuperview() {
    guard superview != nil else { return }
    propagateSkin(why: "movedToSuperview")
  }

  public override func applySkin(_ skin: Skin) {
    super.applySkin(skin)

    contentView.backgroundColor ©= skin.bulletinBackgroundColor
    titleLabel.fontStyle = skin.bulletinTitleStyle
    messageLabel.fontStyle = skin.bulletinMessageStyle
  }

  private func setupTitle() {
    stackView => [
      titleLabel
    ]
  }

  private func setupMessage() {
    stackView => [
      messageLabel
    ]
  }

  public override func syncToModel() {
    super.syncToModel()

    if let title = model.title {
      titleLabel.show()
      titleLabel.text = title
    } else {
      titleLabel.hide()
    }
    if let message = model.message {
      messageLabel.show()
      messageLabel.text = message
    } else {
      messageLabel.hide()
    }
  }
}
