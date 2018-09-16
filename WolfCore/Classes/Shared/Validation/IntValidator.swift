//
//  IntValidator.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/3/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation
import WolfLocale

open class IntValidator: Validator {
    public let validRange: CountableClosedRange<Int>
    private var allowsNegative: Bool {
        return validRange.lowerBound < 0 || validRange.upperBound < 0
    }

    public init(name: String = "Value", isRequired: Bool = true, validRange: CountableClosedRange<Int> = Int.min ... Int.max) {
        self.validRange = validRange
        super.init(name: name, isRequired: isRequired)
    }

    open override func editValidate(_ validation: StringValidation) -> String? {
        return try? validation.containsOnlyValidIntegerCharacters(allowsNegative: allowsNegative).value
    }

    open override func submitValidate(_ validation: StringValidation) throws -> String {
        return try validation.isInteger(in: validRange).value
    }
}

extension StringValidation {
    fileprivate func containsOnlyValidIntegerCharacters(allowsNegative: Bool) throws -> StringValidation {
        guard !value.isEmpty else { return self }

        do {
            if allowsNegative {
                return try pattern("^-?[0-9]*$")
            } else {
                return try pattern("^[0-9]*$")
            }
        } catch is ValidationError {
            throw ValidationError(message: "#{name} contains invalid characters." ¶ ["name": name], violation: "containsOnlyValidIntegerCharacters")
        }
    }

    fileprivate func isInteger(in range: CountableClosedRange<Int>) throws -> StringValidation {
        guard !value.isEmpty else { return self }

        guard let i = Int(value), range.contains(i) else {
            throw ValidationError(message: "#{name} must be an integer from #{low} to #{high}." ¶ ["name": name, "low": String(describing: range.lowerBound), "high": String(describing: range.upperBound)], violation: "integer")
        }
        return self
    }
}
