//
//  Base64.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding data as Base-64 encoded strings.
///
/// For more information: [Base64 on Wikipedia](https://en.wikipedia.org/wiki/Base64)
public struct Base64 {
    public enum Error: Swift.Error {
        /// Thrown if the String cannot be decoded to Data.
        case invalid
    }

    /// The Base-64 encoded representation.
    public let string: String
    /// The raw data.
    public let data: Data

    /// Create a Base64 from a Base-64 encoded string. Throws if the String cannot be decoded to Data.
    ///
    /// May be used as a monad transformer.
    public init(string: String) throws {
        self.string = string
        if let data = Data(base64Encoded: string) {
            self.data = data
        } else {
            throw Error.invalid
        }
    }

    /// Create a Base64 from a Data.
    ///
    /// May be used as a monad transformer.
    public init(data: Data) {
        self.data = data
        string = data.base64EncodedString()
    }
}

extension Base64: CustomStringConvertible {
    public var description: String {
        return "\"\(string)\""
    }
}

extension String {
    /// Extract a Base-64 encoded String from a Base64.
    ///
    /// May be used as a monad transformer.
    public init(base64: Base64) {
        self.init(base64.string)
    }
}

extension Data {
    /// Extract a Data from a Base64.
    ///
    /// May be used as a monad transformer.
    public init(base64: Base64) {
        self.init(base64.data)
    }
}
