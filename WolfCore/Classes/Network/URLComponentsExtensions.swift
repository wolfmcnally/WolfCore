//
//  URLComponentsExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

extension URLComponents {
    public var queryDictionary: [String: String] {
        get {
            var dict = [String: String]()
            guard let queryItems = queryItems else { return dict }
            for item in queryItems {
                if let value = item.value {
                    dict[item.name] = value
                }
            }
            return dict
        }
        
        set {
            let queryItems: [URLQueryItem] = newValue.map {
                return URLQueryItem(name: $0.0, value: $0.1)
            }
            self.queryItems = queryItems
        }
    }
    
    public static func parametersDictionary(from string: String?) -> [String: String] {
        var dict = [String: String]()
        guard let string = string else { return dict }
        let items = string.components(separatedBy: "&")
        for item in items {
            let parts = item.components(separatedBy: "=")
            assert(parts.count == 2)
            dict[parts[0]] = parts[1]
        }
        return dict
    }
}

extension URLComponents {
    public init(scheme: HTTPScheme, host: String, basePath: String? = nil, pathComponents: [Any]? = nil, query: [String : String]? = nil) {
        self.init()
        
        self.scheme = scheme.rawValue
        
        self.host = host
        
        let joiner = Joiner(left: "/", separator: "/")
        if let basePath = basePath {
            joiner.append(basePath)
        }
        if let pathComponents = pathComponents {
            joiner.append(contentsOf: pathComponents)
        }
        self.path = joiner.description
        
        if let query = query {
            queryDictionary = query
        }
    }
}
