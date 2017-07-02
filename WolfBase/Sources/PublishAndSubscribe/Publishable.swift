//
//  Publishable.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol Publishable: Hashable {
  var duration: TimeInterval? { get }
}
