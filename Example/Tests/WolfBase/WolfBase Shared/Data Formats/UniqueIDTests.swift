//
//  UniqueIDTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfCore

class UniqueIDTests: XCTestCase {
    let knownString = "e3456fcb-f453-43d8-b9ef-7cbde0ba20c6"
    let knownData = Data(bytes: [0xe3, 0x45, 0x6f, 0xcb, 0xf4, 0x53, 0x43, 0xd8, 0xb9, 0xef, 0x7c, 0xbd, 0xe0, 0xba, 0x20, 0xc6])
    
    func testUniqueID() {
        let count = 10000
        var s = Set<UniqueID>()
        for _ in 0 ..< count {
            let u = UniqueID()
            s.insert(u)
        }
        XCTAssert(s.count == count)
    }
    
    func testDataToUniqueID() {
        let uniqueID = try! knownData |> UniqueID.init
        XCTAssert(uniqueID.data == knownData)
        XCTAssert(uniqueID.string == knownString)
    }
    
    func testStringToUniqueID() {
        let uniqueID = try! knownString |> UniqueID.init
        XCTAssert(uniqueID.data == knownData)
        XCTAssert(uniqueID.string == knownString)
    }
    
    func testUniqueIDToString() {
        XCTAssert(try! knownData |> UniqueID.init |> String.init == knownString)
    }
    
    func testUniqueIDToData() {
        XCTAssert(try! knownData |> UniqueID.init |> Data.init == knownData)
    }
}
