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

    public override func syncToModel() {
        super.syncToModel()
        if model.flags.contains(.reachable) {
//            skin = Self.reachableSkin
        } else {
//            skin = Self.unreachableSkin
        }
    }
}
