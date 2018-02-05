//
//  RangeExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/18/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension NSRange {
    public init(cfRange: CFRange) {
        self.init(location: cfRange.location, length: cfRange.length)
    }

    public init(range: Range<Int>) {
        self.init(location: range.lowerBound, length: range.count)
    }
}

extension CFRange {
    public init(nsRange: NSRange) {
        self.init(location: nsRange.location, length: nsRange.length)
    }

    public init(range: Range<Int>) {
        self.init(location: range.lowerBound, length: range.count)
    }
}
