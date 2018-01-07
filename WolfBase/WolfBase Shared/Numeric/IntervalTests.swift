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
        let i = Interval(1, 2)
        XCTAssert(i.a == 1)
        XCTAssert(i.b == 2)
        XCTAssert(i.min == 1)
        XCTAssert(i.max == 2)
        XCTAssert(i.isAscending)
        XCTAssert(!i.isDescending)
        XCTAssert(!i.isFlat)
        
        let j = Interval(5, -2)
        XCTAssert(j.a == 5)
        XCTAssert(j.b == -2)
        XCTAssert(j.min == -2)
        XCTAssert(j.max == 5)
        XCTAssert(j.isDescending)
        XCTAssert(!j.isAscending)
        XCTAssert(!j.isFlat)
        
        let range_i = i.closedRange
        XCTAssert(range_i.lowerBound == 1)
        XCTAssert(range_i.upperBound == 2)
        
        let range_j = j.closedRange
        XCTAssert(range_j.lowerBound == -2)
        XCTAssert(range_j.upperBound == 5)
    }
}
