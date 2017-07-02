//
//  MathUtils.swift
//  WolfBase
//
//  Created by Wolf McNally on 7/1/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

extension BinaryFloatingPoint {
  /// Returns this value clamped to between 0.0 and 1.0
  public func clamped() -> Self {
    return max(min(self, 1.0), 0.0)
  }

  public func ledge() -> Bool {
    return self < 0.5
  }

  public func ledge<T>(_ a: @autoclosure () -> T, _ b: @autoclosure () -> T) -> T {
    return self.ledge() ? a() : b()
  }

  public var fractionalPart: Self {
    return self - rounded(.towardZero)
  }
}

extension BinaryInteger {
  public var isEven: Bool {
    return (self & 1) == 0
  }
  
  public var isOdd: Bool {
    return (self & 1) == 1
  }
}
