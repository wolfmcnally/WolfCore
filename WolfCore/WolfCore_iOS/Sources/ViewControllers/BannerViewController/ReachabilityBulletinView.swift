//
//  ReachabilityBulletinView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class ReachabilityBulletinView: MessageBulletinView<ReachabilityBulletin> {
  private typealias `Self` = ReachabilityBulletinView

  public static var reachableSkin: Skin = {
    var skin = darkSkin
    skin.bulletinBackgroundColor = Color.green.darkened(by: 0.4)
    return skin
  }()

  public static var unreachableSkin: Skin = {
    var skin = darkSkin
    skin.bulletinBackgroundColor = .red
    return skin
  }()

  public override func syncToModel() {
    super.syncToModel()
    if model.flags.contains(.reachable) {
      skin = Self.reachableSkin
    } else {
      skin = Self.unreachableSkin
    }
  }
}
