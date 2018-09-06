//
//  HTTPError.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation
import WolfPipe

extension Error {
    public var httpStatusCode: StatusCode? {
        guard let e = self as? HTTPError else { return nil }
        return e.statusCode
    }
}

public struct HTTPError: DescriptiveError {
    public let request: URLRequest
    public let response: HTTPURLResponse
    public let data: Data?

    public init(request: URLRequest, response: HTTPURLResponse, data: Data? = nil) {
        self.request = request
        self.response = response
        self.data = data
    }

    public var message: String {
        return HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var code: Int {
        return response.statusCode
    }

    public var statusCode: StatusCode {
        return StatusCode(rawValue: code)!
    }

    public var identifier: String {
        return "HTTPError(\(code))"
    }

    public var json: JSON? {
        guard let data = data else { return nil }
        do {
            return try data |> JSON.init
        } catch {
            return nil
        }
    }

    public var isCancelled: Bool { return false }
}

extension HTTPError: CustomStringConvertible {
    public var description: String {
        return "HTTPError(\(code) \(message))"
    }
}
