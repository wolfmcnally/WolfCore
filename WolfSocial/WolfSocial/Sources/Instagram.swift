//
//  Instagram.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfBase

public class Instagram: Platform {
    private typealias `Self` = Instagram

    public static let defaultName = "Instagram"

    public override init(name: String = Self.defaultName) {
        super.init(name: name)
    }

    public override func open(userID: String? = nil) throws {
        if let userID = userID {
            try openURL(appTemplate: "instagram://user?username=#{userID}", browserTemplate: "https://instagram.com/#{userID}", userID: userID)
        } else {
            try openURL(appTemplate: "instagram://", browserTemplate: "https://instagram.com/", userID: userID)
        }
    }
}

open class InstagramUsernameValidator: Validator {
    private typealias `Self` = InstagramUsernameValidator

    private static let minLength = 1
    private static let maxLength = 15

    public override init(name: String = Instagram.defaultName, isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.lowercased().maxLength(Self.maxLength).containsOnlyValidInstagramCharacters().value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.lowercased().minLength(Self.minLength).maxLength(Self.maxLength).beginsWithLetter().endsWithLetterOrNumber().containsOnlyValidInstagramCharacters().value
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidInstagramCharacters() throws -> StringValidation {
        do {
            return try pattern("^[_.a-zA-Z0-9]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters.", violation: "containsOnlyValidInstagramCharacters")
        }
    }
}
