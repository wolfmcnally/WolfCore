//
//  Base64URLTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfCore

class Base64URLTests: XCTestCase {
    let knownData = Data(bytes: Array(150..<200))
    let knownString = "lpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq_wsbKztLW2t7i5uru8vb6-wMHCw8TFxsc"
    
    func testDataToBase64URL() {
        let base64url = knownData |> Base64URL.init
        XCTAssert(base64url.data == knownData)
        XCTAssert(base64url.string == knownString)
    }
    
    func testBase64URLToData() {
        let data = try! knownString |> Base64URL.init |> Data.init
        XCTAssert(data == knownData)
    }
    
    func testBase64URLToString() {
        let string = try! knownString |> Base64URL.init |> String.init
        XCTAssert(string == knownString)
    }
}
