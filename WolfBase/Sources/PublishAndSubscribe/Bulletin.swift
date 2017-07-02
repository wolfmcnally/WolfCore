//
//  Bulletin.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public typealias BulletinPublisher = Publisher<Bulletin>
public typealias BulletinSubscriber = Subscriber<Bulletin>

open class Bulletin: Publishable {
  private typealias `Self` = Bulletin
  
  private static var _nextID: Int = 1
  
  public static let minimumPriority = 0
  public static let normalPriority = 500
  public static let maximumPriority = 1000
  
  private static func nextID() -> Int {
    defer { _nextID += 1 }
    return _nextID
  }
  
  public let id: Int
  public let date: Date
  public let priority: Int
  public let duration: TimeInterval?
  
  public init(priority: Int = normalPriority, duration: TimeInterval? = nil) {
    self.id = Self.nextID()
    self.date = Date()
    self.priority = priority
    self.duration = duration
  }
  
  public var hashValue: Int {
    return id
  }
  
  public static func == (lhs: Bulletin, rhs: Bulletin) -> Bool {
    return lhs.id == rhs.id
  }
}
