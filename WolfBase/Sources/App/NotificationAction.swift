//
//  NotificationAction.swift
//  WolfBase
//
//  Created by Wolf McNally on 7/17/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

open class NotificationAction {
  private let observer: NotificationObserver
  public let notificationBlock: NotificationBlock
  
  public init(name: NSNotification.Name, using notificationBlock: @escaping NotificationBlock) {
    self.notificationBlock = notificationBlock
    observer = notificationCenter.addObserver(for: name, using: notificationBlock)
  }
  
  public init(name: NSNotification.Name, object: AnyObject?, using notificationBlock: @escaping NotificationBlock) {
    self.notificationBlock = notificationBlock
    observer = notificationCenter.addObserver(forName: name, object: object, queue: nil, using: notificationBlock)
  }
  
  deinit {
    notificationCenter.removeObserver(observer)
  }
}
