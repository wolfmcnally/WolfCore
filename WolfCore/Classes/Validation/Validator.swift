//
//  Validator.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/18/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

open class Validator {
    public let name: String
    public let isRequired: Bool

    public init(name: String, isRequired: Bool = true) {
        self.name = name
        self.isRequired = isRequired
    }

    open func editValidate(_ validation: StringValidation) -> String? {
        return validation.value
    }

    open func submitValidate(_ validation: StringValidation) throws -> String {
        return validation.value
    }

    /// This is used to validate each change to the field as it is edited. It returns either the original string, a modified form of the original string, or `nil` if the changes are rejected. Typically this evaluates only whether the string (if not `nil`) only contains characters allowed in the final syntax.
    public func editValidate(_ value: String?) -> String? {
        return editValidate(StringValidation(value: value, name: name))
    }

    /// This is used to validate the entire string when it is validated as a whole. It either returns the original string, a modified form of the original string, or throws a `ValidationError` explaining how the string falied to validate.
    public func submitValidate(_ value: String?) throws -> String {
        return try submitValidate(StringValidation(value: value, name: name).required(isRequired))
    }

    /// This is use to validate the entire string asynchronously, typically via a remote API call. If the validation succeeds, the promise is kept. If the validation fails, the promise fails with a `ValidationError`. If some other error occurs, the promise fails with an `Error`.
    open func remoteValidate(_ value: String?) -> SuccessPromise? {
        return nil
    }

    public var remoteValidationSuccessMessage: String?
}
