//
//  GraphError.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfBase

public struct GraphError: ExtensibleEnumeratedName, Error {
  public let rawValue: String
  
  public init(_ rawValue: String) {
    self.rawValue = rawValue
  }
  
  // RawRepresentable
  public init?(rawValue: String) { self.init(rawValue) }
}
