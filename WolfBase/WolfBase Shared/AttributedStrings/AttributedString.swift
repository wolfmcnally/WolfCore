//
//  AttributedString.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public typealias AttributedString = NSMutableAttributedString

public typealias StringAttributes = [NSAttributedStringKey : Any]

public func += (left: AttributedString, right: NSAttributedString) {
    left.append(right)
}
