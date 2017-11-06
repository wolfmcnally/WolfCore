//
//  URLExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/15/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

extension URL {
    public static func retrieveData(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}

extension URL {
    public init(scheme: HTTPScheme, host: String, basePath: String? = nil, pathComponents: [Any]? = nil, query: [String : String]? = nil) {
        let comps = URLComponents(scheme: scheme, host: host, basePath: basePath, pathComponents: pathComponents, query: query)
        self.init(string: comps.string!)!
    }
}

extension URL {
    public func convertedToHTTPS() -> URL {
        var comps = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        comps.scheme = HTTPScheme.https.rawValue
        return comps.url!
    }
}

extension String {
    public static func url(from string: String) throws -> URL {
        guard let url = URL(string: string) else {
            throw ValidationError(message: "Could not parse url from string: \(string)", violation: "urlFormat")
        }
        return url
    }
}
