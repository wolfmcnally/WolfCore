//
//  StringTests.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfBase

class StringTests: XCTestCase {
    func testReplacing() {
        let s = "The #{subjectAdjective} #{subjectColor} #{subjectSpecies} #{action} the #{objectAdjective} #{objectSpecies}." // swiftlint:disable:this line_length
        let replacements: Replacements = [
            "subjectAdjective": "quick",
            "subjectColor": "brown",
            "subjectSpecies": "fox",
            "action": "jumps over",
            "objectAdjective": "lazy",
            "objectSpecies": "dog"
        ]
        let result = s.replacingPlaceholders(with: replacements)
        XCTAssert(result == "The quick brown fox jumps over the lazy dog.")
    }
}
