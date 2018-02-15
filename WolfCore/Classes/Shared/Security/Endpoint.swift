//
//  Endpoint.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public struct Endpoint {
    public let name: String
    public let host: String
    public let basePath: String?

    public init(name: String, host: String, basePath: String? = nil) {
        self.name = name
        self.host = host
        self.basePath = basePath
    }
}
