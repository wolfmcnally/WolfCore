//
//  IntPoint.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/20/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public struct IntPoint {
  public var x: Int = 0
  public var y: Int = 0
}

extension IntPoint: CustomStringConvertible {
  public var description: String {
    return("IntPoint(\(x), \(y))")
  }
}

extension IntPoint {
  public static let zero = IntPoint()
}

extension IntPoint: Equatable {
}

public func == (lhs: IntPoint, rhs: IntPoint) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}
