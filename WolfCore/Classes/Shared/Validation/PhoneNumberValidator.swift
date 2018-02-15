//
//  PhoneNumberValidator.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

open class PhoneNumberValidator: Validator {
    public override init(name: String = "Phone Number", isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.containsOnlyValidPhoneNumberCharacters().value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.isPhoneNumber().value
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidPhoneNumberCharacters() throws -> StringValidation {
        do {
            return try pattern("^[() +._0-9-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters." ¶ ["name": name], violation: "containsOnlyValidPhoneNumberCharacters")
        }
    }

    public func isPhoneNumber() throws -> StringValidation {
        guard matchesDataDetector(type: .phoneNumber) else {
            throw ValidationError(message: "#{name} must be a valid phone number." ¶ ["name": name], violation: "emailAddress")
        }
        return self
    }
}
