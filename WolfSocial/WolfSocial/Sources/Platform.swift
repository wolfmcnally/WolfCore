//
//  Platform.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfCore
import WolfBase

open class Platform {
    public let name: String

    public init(name: String) {
        self.name = name
    }

    public enum Error: Swift.Error {
        case badID(String?)
        case missingScheme
        case disallowedScheme(String)
    }

    private func newURL(with template: String, userID: String?) throws -> URL {
        let string: String
        if let userID = userID {
            string = template.replacingPlaceholders(with: ["userID": userID])
        } else {
            string = template
        }
        guard let url = URL(string: string) else {
            throw Error.badID(userID)
        }
        guard let scheme = url.scheme else {
            throw Error.missingScheme
        }
        let registeredSchemes: [String] = appInfo["LSApplicationQueriesSchemes"] as? [String] ?? []
        let allowedSchemes = registeredSchemes + ["https"]
        guard allowedSchemes.contains(scheme) else {
            throw Error.disallowedScheme(scheme)
        }
        return url
    }

    /// The scheme in `appTemplate` must be registered in the `LSApplicationQueriesSchemes` array in the app's Info.plist.
    /// The scheme in `browserTemplate` should be "https" or else the URL will also need to be registered in `NSAppTransportSecurity` in Info.plist.
    public func openURL(appTemplate: String?, browserTemplate: String, userID: String?) throws {
        if let appTemplate = appTemplate {
            let appURL = try newURL(with: appTemplate, userID: userID)
            guard !UIApplication.shared.canOpenURL(appURL) else {
                UIApplication.shared.openURL(appURL)
                return
            }
        }
        let browserURL = try newURL(with: browserTemplate, userID: userID)
        UIApplication.shared.openURL(browserURL)
    }

    public func open(userID: String? = nil) throws {
        fatalError("Implemented in subclass.")
    }

    public func newUsernameValidator(isRequired: Bool) -> Validator {
        fatalError("Implemented in subclass.")
    }
}
