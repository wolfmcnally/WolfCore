//
//  Mock.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/9/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public struct Mock {
  public let statusCode: StatusCode
  public let delay: TimeInterval
  public let data: Data
  
  public init(statusCode: StatusCode = .ok, delay: TimeInterval = 0.5, data: Data? = nil) {
    self.statusCode = statusCode
    self.delay = delay
    self.data = data ?? Data()
  }
  
  public init(statusCode: StatusCode = .ok, delay: TimeInterval = 0.5, json: JSON) {
    self.init(statusCode: statusCode, delay: delay, data: json.data)
  }
  
  public init(statusCode: StatusCode = .ok, delay: TimeInterval = 0.5, object: JSONRepresentable) {
    self.init(statusCode: statusCode, delay: delay, json: object.json)
  }
  
  public static var internalServerError = Mock(statusCode: .internalServerError)
  public static var unauthorized = Mock(statusCode: .unauthorized)
  public static var notFound = Mock(statusCode: .notFound)
}
