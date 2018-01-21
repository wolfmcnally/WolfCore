//
//  PhoneOrEmailValidator.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/20/18.
//  Copyright © 2018 WolfMcNally.com. All rights reserved.
//

open class PhoneOrEmailValidator: Validator {
    public override init(name: String = "PhoneOrEmail", isRequired: Bool = true) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        if let phoneValue = try? validation.containsOnlyValidPhoneCharacters().value {
            return phoneValue
        }
        if let emailValue = try? validation.containsOnlyValidEmailCharacters().value {
            return emailValue
        }
        return nil
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        if let phoneValue = try? validation.isPhone().value {
            return phoneValue
        }
        if let emailValue = try? validation.isEmail().value {
            return emailValue
        }
        throw ValidationError(message: "#{name} must be a phone or email." ¶ ["name": name], violation: "phoneOrEmail")
    }
}
