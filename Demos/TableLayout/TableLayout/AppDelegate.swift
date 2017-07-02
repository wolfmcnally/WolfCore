//
//  AppDelegate.swift
//  TableLayout
//
//  Created by Robert McNally on 7/6/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore
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
    logger.setGroup(.skinC, active: false)
  }
}
