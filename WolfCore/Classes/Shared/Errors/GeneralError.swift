//
//  GeneralError.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

/// Represents a non-specific error result.
public struct GeneralError: DescriptiveError {
    /// A human-readable error message
    public var message: String

    /// A numeric code for the error
    public var code: Int

    public init(message: String, code: Int = 1) {
        self.message = message
        self.code = code
    }

    public var identifier: String {
        return "GeneralError(\(code))"
    }

    public let isCancelled = false
}

/// Provides string conversion for GeneralError.
extension GeneralError: CustomStringConvertible {
    public var description: String {
        return "GeneralError(\(message), code: \(code))"
    }
}
