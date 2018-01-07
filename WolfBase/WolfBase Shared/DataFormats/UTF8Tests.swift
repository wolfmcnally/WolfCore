//
//  UTF8Tests.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfBase

class UTF8Tests: XCTestCase {
    let knownData = try! "f09f92aaf09f8fbdf09f90bae29da4efb88f" |> Hex.init |> Data.init
    let knownString = "💪🏽🐺❤️"
    
    func testDataToUTF8() {
        let utf8 = try! knownData |> UTF8.init
        XCTAssert(utf8.data == knownData)
        XCTAssert(utf8.string == knownString)
    }
    
    func testUTF8ToData() {
        let data = knownString |> Data.init
        XCTAssert(data == knownData)
    }
}
