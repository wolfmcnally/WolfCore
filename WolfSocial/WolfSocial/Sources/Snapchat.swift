//
//  Snapchat.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfBase

public class Snapchat: Platform {
    private typealias `Self` = Snapchat

    public static let defaultName = "Snapchat"

    public override init(name: String = Self.defaultName) {
        super.init(name: name)
    }

    public override func open(userID: String? = nil) throws {
        if let userID = userID {
            try openURL(appTemplate: "snapchat://add/#{userID}", browserTemplate: "https://www.snapchat.com/add/#{userID}", userID: userID)
        } else {
            try openURL(appTemplate: "snapchat://", browserTemplate: "https://www.snapchat.com/", userID: userID)
        }
    }
}

open class SnapchatUsernameValidator: Validator {
    private typealias `Self` = SnapchatUsernameValidator

    private static let minLength = 3
    private static let maxLength = 15

    public override init(name: String = Snapchat.defaultName, isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.lowercased().maxLength(Self.maxLength).containsOnlyValidSnapchatCharacters().value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.lowercased().minLength(Self.minLength).maxLength(Self.maxLength).beginsWithLetter().endsWithLetterOrNumber().containsOnlyValidSnapchatCharacters().value
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidSnapchatCharacters() throws -> StringValidation {
        do {
            return try pattern("^[a-zA-Z0-9_.\\-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidSnapchatCharacters")
        }
    }
}
