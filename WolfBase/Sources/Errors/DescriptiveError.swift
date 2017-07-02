//
//  DescriptiveError.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/3/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public protocol DescriptiveError: Error, CustomStringConvertible {
  /// A human-readable error message.
  var message: String { get }
  
  /// A numeric code for the error.
  var code: Int { get }
  
  /// A non-user-facing identifier used for automated UI testing
  var identifier: String { get }
  
  var isCancelled: Bool { get }
}
