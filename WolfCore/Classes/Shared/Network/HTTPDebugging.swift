//
//  HTTPDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/3/16.
//  Copyright © 2016 WolfMcNally.com.
//

import Foundation
import WolfPipe

extension URLRequest {
    public func printRequest(includeAuxFields: Bool = false, level: Int = 0) {
        print("➡️ \(httpMethod†) \(url†)".indented(level))

        let level = level + 1

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                print("\(key): \(value)".indented(level))
            }
        }

        if let data = httpBody, data.count > 0 {
            print("body:".indented(level))

            let level = level + 1
            do {
                try print((data |> JSON.init).prettyString.indented(level))
            } catch {
                print("Non-JSON Data: \(data)".indented(level))
            }
        }

        guard includeAuxFields else { return }

        let cachePolicyStrings: [URLRequest.CachePolicy: String] = [
            .useProtocolCachePolicy: ".useProtocolCachePolicy",
            .reloadIgnoringLocalCacheData: ".reloadIgnoringLocalCacheData",
            .returnCacheDataElseLoad: ".returnCacheDataElseLoad",
            .returnCacheDataDontLoad: ".returnCacheDataDontLoad"
            ]
        let networkServiceTypes: [URLRequest.NetworkServiceType: String]
        if #available(iOS 10.0, *) {
            networkServiceTypes = [
                .`default`: ".default",
                .voip: ".voip",
                .video: ".video",
                .background: ".background",
                .voice: ".voice",
                .callSignaling: ".callSignaling"
            ]
        } else {
            networkServiceTypes = [
                .`default`: ".default",
                .voip: ".voip",
                .video: ".video",
                .background: ".background",
                .voice: ".voice"
            ]
        }

        print("timeoutInterval: \(timeoutInterval)".indented(level))
        print("cachePolicy: \(cachePolicyStrings[cachePolicy]!)".indented(level))
        print("allowsCellularAccess: \(allowsCellularAccess)".indented(level))
        print("httpShouldHandleCookies: \(httpShouldHandleCookies)".indented(level))
        print("httpShouldUsePipelining: \(httpShouldUsePipelining)".indented(level))
        print("mainDocumentURL: \(mainDocumentURL†)".indented(level))
        print("networkServiceType: \(networkServiceTypes[networkServiceType]!)".indented(level))
    }
}
