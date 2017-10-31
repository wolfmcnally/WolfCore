//
//  StringValidation.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public struct StringValidation: Validation {
  public let value: String
  public let name: String

  public init(value: String?, name: String) {
    self.name = name
    self.value = value ?? ""
  }
}

extension StringValidation {
  public func required(_ isRequired: Bool = true) throws -> StringValidation {
    guard isRequired else { return self }
    guard !value.isEmpty else {
      throw ValidationError(message: "#{name} is required." ¶ ["name": name], violation: "required")
    }
    return self
  }

  public func minLength(_ minLength: Int?) throws -> StringValidation {
    guard let minLength = minLength else { return self }
    guard value.count >= minLength else {
      throw ValidationError(message: "#{name} must be at least #{minLength} characters." ¶ ["name": name, "minLength": String(minLength)], violation: "minLength")
    }
    return self
  }

  public func maxLength(_ maxLength: Int?) throws -> StringValidation {
    guard let maxLength = maxLength else { return self }
    guard value.count <= maxLength else {
      throw ValidationError(message: "#{name} may not be more than #{maxLength} characters." ¶ ["name": name, "maxLength": String(maxLength)], violation: "maxLength")
    }
    return self
  }

  public func trimmed() -> StringValidation {
    return StringValidation(value: value.trimmed(), name: name)
  }

  public func lowercased() -> StringValidation {
    return StringValidation(value: value.lowercased(), name: name)
  }

  public func pattern(_ pattern: String) throws -> StringValidation {
    let regex = try! ~/pattern
    guard (regex ~? value) else {
      throw ValidationError(message: "#{name} contains invalid characters." ¶ ["name": name], violation: "pattern")
    }
    return self
  }

  public func beginsWithLetter() throws -> StringValidation {
    do {
      return try pattern("^[a-zA-Z]")
    } catch is ValidationError {
      throw ValidationError(message: "#{name} must begin with a letter." ¶ ["name": name], violation: "beginsWithLetter")
    }
  }

  public func beginsWithLetterOrNumber() throws -> StringValidation {
    do {
      return try pattern("^[a-zA-Z0-9]")
    } catch is ValidationError {
      throw ValidationError(message: "#{name} must begin with a letter or number." ¶ ["name": name], violation: "beginsWithLetterOrNumber")
    }
  }

  public func endsWithLetterOrNumber() throws -> StringValidation {
    do {
      return try pattern("[a-zA-Z0-9]$")
    } catch is ValidationError {
      throw ValidationError(message: "#{name} must end with a letter or number." ¶ ["name": name], violation: "endsWithLetterOrNumber")
    }
  }

  public func containsDigit() throws -> StringValidation {
    do {
      return try pattern("[0-9]")
    } catch is ValidationError {
      throw ValidationError(message: "#{name} must contain a digit." ¶ ["name": name], violation: "containsDigit")
    }
  }

  func matchesDataDetector(type: TextCheckingResult.CheckingType, scheme: String? = nil) -> Bool {
    let dataDetector = try! NSDataDetector(types: type.rawValue)
    let length = (value as NSString).length
    let range = NSRange(location: 0, length: length)
    guard let firstMatch = dataDetector.firstMatch(in: value, options: .reportCompletion, range: range) else {
      return false
    }
    return
      // make sure the entire string is an email, not just contains an email
      firstMatch.range == range
        // make sure the link type matches if link scheme
        && (type != .link || scheme == nil || firstMatch.url?.scheme == scheme)
  }
}
