//
//  IntervalTests.swift
//  WolfBaseTests
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfBase

class IntervalTests: XCTestCase {
    func test1() {
        let i = Interval(a: 1, b: 2)
        XCTAssert(i.a == 1)
        XCTAssert(i.b == 2)
        XCTAssert(i.isAscending)
        XCTAssert(!i.isDescending)
        XCTAssert(!i.isFlat)
        
        let j = Interval(a: 5, b: -2)
        XCTAssert(j.a == 5)
        XCTAssert(j.b == -2)
        XCTAssert(j.isDescending)
        XCTAssert(!j.isAscending)
        XCTAssert(!j.isFlat)
    }
}
