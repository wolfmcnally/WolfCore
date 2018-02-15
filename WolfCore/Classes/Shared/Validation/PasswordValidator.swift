//
//  PasswordValidator.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

open class PasswordValidator: Validator {
    public override init(name: String = "Password", isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.maxLength(24).value
    }
}

open class CreatePasswordValidator: PasswordValidator {
    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.minLength(4).maxLength(24).containsDigit().value
    }
}
