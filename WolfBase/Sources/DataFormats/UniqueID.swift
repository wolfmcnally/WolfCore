//
//  UniqueID.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/14/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding unique identifiers (UUIDs)
public struct UniqueID {
  /// The size of a uuid in bytes
  public let uuidSize = MemoryLayout<uuid_t>.size

  public enum Error: Swift.Error {
    /// Thrown if the String cannot be decoded to UUID.
    case invalid
  }

  /// The underlying Foundation UUID object, which is itself a wrapper for a Unix uuid_t struct.
  public let uuid: Foundation.UUID

  /// The representation of this UniqueID as a String/
  public var string: String {
    return self.uuid.uuidString |> String.lowercased
  }

  /// The UniqueID as a Data/
  public var data: Data {
    var u = uuid.uuid
    return withUnsafePointer(to: &u) { p in
      return Data(bytes: UnsafePointer(p), count: uuidSize)
    }
  }

  /// Create a new, unique identifier/
  public init() {
    self.uuid = Foundation.UUID()
  }

  /// Construct a UniqueID from a String.
  ///
  /// May be used as a monad transformer.
  public init(string: String) throws {
    guard let uuid = Foundation.UUID(uuidString: string) else { throw type(of: self).Error.invalid }
    self.uuid = uuid
  }

  /// Construct a UniqueID from a Data.
  ///
  /// May be used as a monad transformer.
  public init(d: Data) throws {
    guard d.count == uuidSize else { throw type(of: self).Error.invalid }
    let u: uuid_t = (d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15])
    self.uuid = Foundation.UUID(uuid: u)
  }
}

extension UniqueID: Hashable {
  public var hashValue: Int {
    return uuid.hashValue
  }
}

extension UniqueID: Equatable {
}

public func == (left: UniqueID, right: UniqueID) -> Bool {
  return left.uuid == right.uuid
}

extension UniqueID: CustomStringConvertible {
  public var description: String {
    return string
  }
}

extension String {
  /// Extract a String from a UniqueID.
  ///
  /// May be used as a monad transformer.
  public init(uniqueID: UniqueID) {
    self.init(uniqueID.string)
  }
}

extension Data {
  /// Extract a Data from a UniqueID.
  ///
  /// May be used as a monad transformer.
  public init(uniqueID: UniqueID) {
    self.init(uniqueID.data)
  }
}

extension UUID {
  /// Extract a Foundation.UUID from a UniqueID.
  ///
  /// May be used as a monad transformer.
  public init(uniqueID: UniqueID) {
    self.init(uuid: uniqueID.uuid.uuid)
  }
}
