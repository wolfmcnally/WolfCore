//
//  Facebook.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfBase

public class Facebook: Platform {
    private typealias `Self` = Facebook

    public static let defaultName = "Facebook"

    public override init(name: String = Self.defaultName) {
        super.init(name: name)
    }

    public override func open(userID: String? = nil) throws {
        if let userID = userID {
            // Facebook DOES NOT support a way to link into the native iOS app. The schema "fb://profile/#{userID}" does not work, nor does app-scoped IDs. See https://developers.facebook.com/bugs/332195860270199
            try openURL(appTemplate: nil, browserTemplate: "https://www.facebook.com/#{userID}", userID: userID)
        } else {
            try openURL(appTemplate: nil, browserTemplate: "https://www.facebook.com/", userID: userID)
        }
    }
}

public class FacebookUsernameValidator: Validator {
    private typealias `Self` = FacebookUsernameValidator

    private static let minLength = 5
    private static let maxLength = 50

    public override init(name: String = Facebook.defaultName, isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.maxLength(Self.maxLength).containsOnlyValidFacebookCharacters().value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.minLength(Self.minLength).maxLength(Self.maxLength).beginsWithLetterOrNumber().endsWithLetterOrNumber().containsOnlyValidFacebookCharacters().value
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidFacebookCharacters() throws -> StringValidation {
        do {
            return try pattern("^[.a-zA-Z0-9]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidFacebookCharacters")
        }
    }
}
