//
//  ValidationError.swift
//  WolfBase
//
//  Created by Wolf McNally on 2/2/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public struct ValidationError: DescriptiveError {
    public let isCancelled = false
    
    public let message: String
    public let violation: String
    public let source: String?
    public let code: Int
    
    public init(message: String, violation: String, source: String? = nil, code: Int = 1) {
        self.message = message
        self.violation = violation
        self.source = source
        self.code = code
    }
    
    public var identifier: String {
        if let fieldIdentifier = source {
            return "\(fieldIdentifier)-\(violation)"
        } else {
            return "\(violation)"
        }
    }
}

extension ValidationError: CustomStringConvertible {
    public var description: String {
        return "ValidationError(\(message) [\(identifier)])"
    }
}
