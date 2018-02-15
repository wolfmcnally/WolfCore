//
//  Error.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/3/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

public typealias ErrorBlock = (Error) -> Void

// Conforms NSError to the Error protocol.
extension NSError: DescriptiveError {
    public var message: String {
        return localizedDescription
    }

    public var identifier: String {
        return "NSError(\(code))"
    }
}

extension NSError {
    public var isNotConnectedToInternet: Bool {
        return domain == NSURLErrorDomain && code == NSURLErrorNotConnectedToInternet
    }

    public var isCancelled: Bool {
        return domain == NSURLErrorDomain && code == NSURLErrorCancelled
    }

    // Thrown by poorly-bridged Objective-C frameworks.
    public var isNilError: Bool {
        return domain == "Foundation._GenericObjCError" && code == 0
    }
}
