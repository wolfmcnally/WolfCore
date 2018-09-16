//
//  Typesetter.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/20/17.
//  Copyright © 2017 WolfMcNally.com.
//

import CoreText
import WolfStrings

public struct Typesetter {
    private let attrString: AttributedString
    private let typesetter: CTTypesetter

    private var string: String { return attrString.string }

    public init(attrString: AttributedString) {
        self.attrString = attrString
        typesetter = CTTypesetterCreateWithAttributedString(attrString)
    }

    public func createLine(for range: StringRange? = nil) -> TypeLine {
        let range = range ?? string.stringRange
        return TypeLine(ctLine: CTTypesetterCreateLine(typesetter, string.cfRange(from: range)!))
    }

    public func suggestLineBreak(startingAt startIndex: StringIndex, width: CGFloat) -> StringRange {
        let nsLocation = string.nsLocation(fromIndex: startIndex)
        let nsLength = CTTypesetterSuggestLineBreak(typesetter, nsLocation, Double(width))
        return string.stringRange(nsLocation: nsLocation, nsLength: nsLength)!
    }
}
