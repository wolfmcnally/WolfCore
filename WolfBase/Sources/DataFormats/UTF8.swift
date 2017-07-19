//
//  UTF8.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding data base hexadecimal encoded string.
public struct UTF8 {
  public enum Error: Swift.Error {
    /// Thrown if the Data cannot be decoded to String.
    case invalid
  }

  /// The String.
  public let string: String
  /// The raw data for the String as encoded in UTF-8.
  public let data: Data

  /// Create a UTF8 from a Data. Throws if the Data does not represent a valid UTF-8 encoded String.
  ///
  /// May be used as a monad transformer.
  public init(data: Data) throws {
    guard let string = String(data: data, encoding: .utf8) else {
      throw Error.invalid
    }
    self.data = data
    self.string = string
  }

  /// Create a UTF8 from a String.
  ///
  /// May be used as a monad transformer.
  public init(string: String) {
    self.data = Data(bytes: Array(string.utf8))
    self.string = string
  }
}

extension UTF8: CustomStringConvertible {
  public var description: String {
    return "\"\(string)\""
  }
}

extension String {
  /// Extract a String from a UTF8.
  ///
  /// May be used as a monad transformer.
  public init(utf8: UTF8) {
    self.init(utf8.string)
  }
}

extension Data {
  /// Extract a Data from a UTF8.
  ///
  /// May be used as a monad transformer.
  public init(utf8: UTF8) {
    self.init(utf8.data)
  }
}
