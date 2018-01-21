//
//  EmailValidator.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

open class EmailValidator: Validator {
    public override init(name: String = "Email", isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }
    
    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.containsOnlyValidEmailCharacters().value
    }
    
    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.isEmail().value
    }
}

extension StringValidation {
    func containsOnlyValidEmailCharacters() throws -> StringValidation {
        do {
            return try pattern("^[_+.a-zA-Z0-9@-]*$")
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters." ¶ ["name": name], violation: "containsOnlyValidEmailCharacters")
        }
    }
    
    func isEmail() throws -> StringValidation {
        guard matchesDataDetector(type: .link, scheme: "mailto") else {
            throw ValidationError(message: "#{name} must be a valid email address." ¶ ["name": name], violation: "emailAddress")
        }
        return self
    }
}
