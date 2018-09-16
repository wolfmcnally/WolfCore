//
//  PhoneValidator.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com.
//

import WolfLocale

open class PhoneValidator: Validator {
    public override init(name: String = "Email", isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.containsOnlyValidPhoneCharacters().value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.isEmail().value
    }
}

extension StringValidation {
    func containsOnlyValidPhoneCharacters() throws -> StringValidation {
        do {
            return try pattern("^[+.0-9-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters." ¶ ["name": name], violation: "containsOnlyValidPhoneCharacters")
        }
    }

    func isPhone() throws -> StringValidation {
        guard matchesDataDetector(type: .phoneNumber) else {
            throw ValidationError(message: "#{name} must be a phone number." ¶ ["name": name], violation: "phoneNumber")
        }
        return self
    }
}
