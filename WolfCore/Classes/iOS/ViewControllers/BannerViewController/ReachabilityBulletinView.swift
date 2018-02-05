//
//  ReachabilityBulletinView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class ReachabilityBulletinView: MessageBulletinView<ReachabilityBulletin> {
    private typealias `Self` = ReachabilityBulletinView

    public override func syncToBulletin() {
        super.syncToBulletin()
        if specificBulletin.flags.contains(.reachable) {
//            skin = Self.reachableSkin
        } else {
//            skin = Self.unreachableSkin
        }
    }
}
