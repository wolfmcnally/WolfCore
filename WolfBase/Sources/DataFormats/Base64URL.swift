//
//  Base64URL.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Utilities for encoding and decoding data as Base-64 URL encoded strings.
///
/// For more information: [Base64URL on Wikipedia](https://en.wikipedia.org/wiki/Base64#URL_applications)
public struct Base64URL {
    /// The Base-64 URL-encoded representation.
    public let string: String
    
    /// The raw data.
    public var data: Data {
        return base64.data
    }
    
    let base64: Base64
    
    /// Create a Base64URL from a Base64.
    ///
    /// May be used as a monad transformer.
    init(base64: Base64) {
        self.base64 = base64
        self.string = base64.string |> Base64URL.toBase64URLString
    }
    
    /// Create a Base64URL from a Base-64 URL encoded string. Throws if the String cannot be decoded to Data.
    ///
    /// May be used as a monad transformer.
    public init(string: String) throws {
        try self.init(base64: string |> Base64URL.toBase64String |> Base64.init)
    }
    
    /// Create a Base64URL from a Data.
    ///
    /// May be used as a monad transformer.
    public init(data: Data) {
        self.init(base64: data |> Base64.init)
    }
}

extension Base64URL: CustomStringConvertible {
    public var description: String {
        return "\"\(string)\""
    }
}

extension String {
    /// Extract a Base-64 URL encoded String from a Base64URL.
    ///
    /// May be used as a monad transformer.
    public init(base64URL: Base64URL) {
        self.init(base64URL.string)
    }
}

extension Data {
    /// Extract a Data from a Base64URL.
    ///
    /// May be used as a monad transformer.
    public init(base64URL: Base64URL) {
        self.init(base64: base64URL.base64)
    }
}

extension Base64URL {
    static func toBase64URLString(string: String) -> String {
        var s2 = ""
        for c in string {
            switch c {
            case Character("+"):
                s2.append(Character("_"))
            case Character("/"):
                s2.append(Character("-"))
            case Character("="):
                break
            default:
                s2.append(c)
            }
        }
        return s2
    }
    
    static func toBase64String(string: String) -> String {
        var s2 = ""
        let chars = string
        for c in chars {
            switch c {
            case Character("_"):
                s2.append(Character("+"))
            case Character("-"):
                s2.append(Character("/"))
            default:
                s2.append(c)
            }
        }
        switch chars.count % 4 {
        case 2:
            s2 += "=="
        case 3:
            s2 += "="
        default:
            break
        }
        return s2
    }
}
