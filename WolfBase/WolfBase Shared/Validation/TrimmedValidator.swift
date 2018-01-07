//
//  TrimmedValidator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

open class TrimmedValidator: Validator {
    public override init(name: String = "", isRequired: Bool = false) {
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return validation.trimmed().value
    }
}
