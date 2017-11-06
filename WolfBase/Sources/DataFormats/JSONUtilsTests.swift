//
//  JSONUtilsTests.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfBase

public class JSONUtilsTests: XCTestCase {
    func test1() {
        let google = "https://google.com/"
        let googleURL = URL(string: google)!
        let appleURL = URL(string: "https://apple.com/")!
        
        let dict: JSON.Dictionary = [
            "name": "Fred",
            "nickname": JSON.null,
            "age": 21,
            "perceivedAge": JSON.null,
            "red": "#FF0000",
            "squant": JSON.null,
            "google": google,
            "2all": JSON.null,
            ]
        
        let json = try! JSON(value: dict)
        
        XCTAssert(try json.getValue(for: "nickname") as String? == nil)
        XCTAssert(try json.getValue(for: "sex") as String? == nil)
        XCTAssert(try json.getValue(for: "age") == 21)
        XCTAssertThrowsError(try json.getValue(for: "age") == "twentyOne")
        
        XCTAssert(try json.getValue(for: "sex", with: "m") == "m")
        XCTAssertThrowsError(try json.getValue(for: "age", with: "m") == "m")
        
        XCTAssert(try json.getValue(for: "name") == "Fred")
        XCTAssert(try json.getValue(for: "name", with: "Jim") == "Fred")
        
        XCTAssert(try json.getValue(for: "nickname") as String? == nil)
        XCTAssert(try json.getValue(for: "nickname", with: "Mutt") == "Mutt")
        XCTAssertThrowsError(try json.getValue(for: "nickname", with: nil) == "Mutt")
        
        XCTAssert(try json.getValue(for: "nonexistentKey") as String? == nil)
        XCTAssert(try json.getValue(for: "nonexistentKey", with: "Mutt") == "Mutt")
        XCTAssertThrowsError(try json.getValue(for: "nonexistentKey", with: nil) == "Mutt")
        
        
        XCTAssert(try json.getValue(for: "age") == 21)
        XCTAssert(try json.getValue(for: "age", with: 18) == 21)
        XCTAssert(try json.getValue(for: "age", with: nil) == 21)
        
        XCTAssert(try json.getValue(for: "perceivedAge") as Int? == nil)
        XCTAssert(try json.getValue(for: "perceivedAge", with: 18) == 18)
        XCTAssertThrowsError(try json.getValue(for: "perceivedAge", with: nil) == 18)
        
        XCTAssert(try json.getValue(for: "nonexistentKey") as Int? == nil)
        XCTAssert(try json.getValue(for: "nonexistentKey", with: 18) == 18)
        XCTAssertThrowsError(try json.getValue(for: "nonexistentKey", with: nil) == 18)
        
        
        XCTAssert(try json.getValue(for: "red") == .red)
        XCTAssert(try json.getValue(for: "red", with: .blue) == .red)
        XCTAssert(try json.getValue(for: "red", with: nil) == Color.red)
        
        XCTAssert(try json.getValue(for: "squant") as Color? == nil)
        XCTAssert(try json.getValue(for: "squant", with: .blue) == .blue)
        XCTAssertThrowsError(try json.getValue(for: "squant", with: nil) == Color.blue)
        
        XCTAssert(try json.getValue(for: "nonexistentKey") as Color? == nil)
        XCTAssert(try json.getValue(for: "nonexistentKey", with: .blue) == .blue)
        XCTAssertThrowsError(try json.getValue(for: "nonexistentKey", with: nil) == Color.blue)
        
        
        XCTAssert(try json.getValue(for: "google") == googleURL)
        XCTAssert(try json.getValue(for: "google", with: appleURL) == googleURL)
        XCTAssert(try json.getValue(for: "google", with: nil) == googleURL)
        
        XCTAssert(try json.getValue(for: "2all") as URL? == nil)
        XCTAssert(try json.getValue(for: "2all", with: appleURL) == appleURL)
        XCTAssertThrowsError(try json.getValue(for: "2all", with: nil) == appleURL)
        
        XCTAssert(try json.getValue(for: "nonexistentKey") as URL? == nil)
        XCTAssert(try json.getValue(for: "nonexistentKey", with: appleURL) == appleURL)
        XCTAssertThrowsError(try json.getValue(for: "nonexistentKey", with: nil) == appleURL)
    }
}
