//
//  ResourceUtils.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public func loadData(named name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil, in bundle: Bundle? = nil) throws -> Data {
    let bundle = bundle ?? Bundle.main
    return try bundle |> Bundle.urlForResource(name, withExtension: anExtension, subdirectory: subpath) |> URL.retrieveData
}

public func loadJSON(at url: URL) throws -> JSON {
    return try url |> URL.retrieveData |> JSON.init
}

public func loadJSON(named name: String, subdirectory subpath: String? = nil, in bundle: Bundle? = nil) throws -> JSON {
    return try loadData(named: name, withExtension: "json", subdirectory: subpath, in: bundle) |> JSON.init
}

public struct ResourceReference: ExtensibleEnumeratedName, Reference {
    public let rawValue: String
    public let type: String?
    public let bundle: Bundle
    
    public init(_ rawValue: String, ofType type: String? = nil, in bundle: Bundle? = nil) {
        self.rawValue = rawValue
        self.type = type
        self.bundle = bundle ?? Bundle.main
    }
    
    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
    
    // Reference
    public var referent: URL {
        return URL(fileURLWithPath: bundle.path(forResource: rawValue, ofType: type)!)
    }
}

public postfix func ® (lhs: ResourceReference) -> URL {
    return lhs.referent
}
