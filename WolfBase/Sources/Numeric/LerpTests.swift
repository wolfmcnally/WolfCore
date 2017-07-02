//
//  LerpTests.swift
//  WolfBaseTests
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import XCTest
@testable import WolfBase

class LerpTests: XCTestCase {
  var epsilon = 1.0e-06
  
  func testLerpedFromIntRange() {
    XCTAssertEqualWithAccuracy(5.lerpedFromRange(0...10, to: 0..100), 50.0, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(5.lerpedFromRange(0..<10, to: 0..90), 50.0, accuracy: epsilon)
  }
  
  func testLerped() {
    XCTAssertEqualWithAccuracy(5.0.lerped(from: 0..10, to:0..1), 0.5, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(5.0.lerped(from: 10..0, to:0..1), 0.5, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(6.0.lerped(from: 1..11, to:0..1), 0.5, accuracy: epsilon)
    XCTAssertEqualWithAccuracy((-1.0).lerped(from: -1..(-11), to:0..1), 0.0, accuracy: epsilon)
  }
  
  func testLerpedFromFrac() {
    XCTAssertEqualWithAccuracy(0.5.lerpedFromFrac(to: 0..10), 5.0, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(0.5.lerpedFromFrac(to: 10..0), 5.0, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(0.0.lerpedFromFrac(to: -1..(-11)), -1.0, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(1.0.lerpedFromFrac(to: -1..(-11)), -11.0, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(0.5.lerpedFromFrac(to: -1..(-11)), -6.0, accuracy: epsilon)
  }
  
  func testLerpedToFrac() {
    XCTAssertEqualWithAccuracy(5.0.lerpedToFrac(from: 0..10), 0.5, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(5.0.lerpedToFrac(from: 10..0), 0.5, accuracy: epsilon)
    XCTAssertEqualWithAccuracy(6.0.lerpedToFrac(from: 1..11), 0.5, accuracy: epsilon)
    XCTAssertEqualWithAccuracy((-1.0).lerpedToFrac(from: -1..(-11)), 0.0, accuracy: epsilon)
  }
}
