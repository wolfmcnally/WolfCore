//
//  Interpolable.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/11/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public protocol Interpolable {
  func interpolated(to other: Self, at frac: Frac) -> Self
}
