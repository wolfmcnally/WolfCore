//
//  ViewNesting.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

@discardableResult public func => (lhs: OSView, rhs: [OSView]) -> OSView {
  rhs.forEach { lhs.addSubview($0) }
  return lhs
}

@discardableResult public func => (lhs: OSStackView, rhs: [OSView]) -> OSStackView {
  rhs.forEach { lhs.addArrangedSubview($0) }
  return lhs
}

