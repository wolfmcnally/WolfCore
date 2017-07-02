//
//  AppDelegate.swift
//  Banners
//
//  Created by Wolf McNally on 5/22/17.
//  Copyright © 2017 Arciem LLC. All rights reserved.
//

import UIKit
import WolfBase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }

    private func setup() {
        setupLogging()
    }

    private func setupLogging() {
        guard let logger = logger else { return }
        logger.level = .trace
        logger.setGroup(.reachability, active: true)
    }
}
