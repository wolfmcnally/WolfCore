//
//  SequenceExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

extension Sequence where Iterator.Element == String {
    public var spaceSeparated: String {
        return joined(separator: .space)
    }

    public var tabSeparated: String {
        return joined(separator: .tab)
    }

    public var commaSeparated: String {
        return joined(separator: .comma)
    }

    public var newlineSeparated: String {
        return joined(separator: .newline)
    }

    public var crlfSeparated: String {
        return joined(separator: .crlf)
    }
}
