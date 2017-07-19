//
//  StringFloatPrecision.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

extension String {
  public init(value: Double, precision: Int) {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = precision
    self.init(formatter.string(from: NSNumber(value: value))!)
  }

  public init(value: Float, precision: Int) {
    self.init(value: Double(value), precision: precision)
  }
}

infix operator %%

public func %% (left: Double, right: Int) -> String {
  return String(value: left, precision: right)
}

public func %% (left: Float, right: Int) -> String {
  return String(value: left, precision: right)
}

#if !os(Linux)
  #if os(macOS)
    import Cocoa
  #else
    import UIKit
  #endif

  extension String {
    public init(value: CGFloat, precision: Int) {
      self.init(value: Double(value), precision: precision)
    }
  }

  public func %% (left: CGFloat, right: Int) -> String {
    return String(value: left, precision: right)
  }
#endif

