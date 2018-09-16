//
//  Publishable.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation

public protocol Publishable: Hashable {
    var duration: TimeInterval? { get }
}
