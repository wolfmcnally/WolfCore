//
//  LexNumTests.swift
//  WolfBase
//
//  Created by Wolf McNally on 10/31/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfBase

public class LexNumTests: XCTestCase {
    func test1() {
        let cases = [
            (-1234567891, "---7898765432108"),
            (-1234567890, "---7898765432109"),
            (-1234567889, "---7898765432110"),
            (-11, "--788"),
            (-10, "--789"),
            (-9, "-0"),
            (-2, "-7"),
            (-1, "-8"),
            (0, "0"),
            (1, "=1"),
            (2, "=2"),
            (9, "=9"),
            (10, "==210"),
            (11, "==211"),
            (1234567889, "===2101234567889"),
            (1234567890, "===2101234567890"),
            (1234567891, "===2101234567891")
        ]
        for c in cases {
            let (n, s) = c
            let a = n |> LexNum.init |> String.init
            XCTAssert(a == s)
            let b = try! a |> LexNum.init |> Int.init
            XCTAssert(b == n)
        }
    }
}
