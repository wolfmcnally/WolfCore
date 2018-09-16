//
//  UUIDValidator.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/3/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation
import WolfLocale

open class UUIDValidator: Validator {
    public let isUppercase: Bool

    public init(name: String = "UUID", isRequired: Bool = true, isUppercase: Bool = true) {
        self.isUppercase = isUppercase
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.containsOnlyValidUUIDCharacters(isUppercase: isUppercase).value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.isUUID(isUppercase: isUppercase).value
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidUUIDCharacters(isUppercase: Bool) throws -> StringValidation {
        guard !value.isEmpty else { return self }

        var validation = self
        if isUppercase {
            validation = uppercased()
        } else {
            validation = lowercased()
        }
        do {
            return try validation.pattern("^[0-9a-fA-f-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters." ¶ ["name": name], violation: "containsOnlyValidUUIDCharacters")
        }
    }

    fileprivate func isUUID(isUppercase: Bool) throws -> StringValidation {
        guard !value.isEmpty else { return self }

        var validation = self
        if isUppercase {
            validation = uppercased()
        } else {
            validation = lowercased()
        }
        guard UUID(uuidString: validation.value) != nil else {
            throw ValidationError(message: "#{name} must be UUID in 8-4-4-4-12 format." ¶ ["name": name], violation: "uuid")
        }
        return validation
    }
}
