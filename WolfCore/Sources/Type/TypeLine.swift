//
//  TypeLine.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreText

public class TypeLine {
    private let ctLine: CTLine

    public private(set) lazy var trailingWhitespaceWidth = CGFloat(CTLineGetTrailingWhitespaceWidth(ctLine))

    public private(set) lazy var typeBounds: TypeBounds = {
        var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
        let width = CGFloat(CTLineGetTypographicBounds(ctLine, &ascent, &descent, &leading)) - trailingWhitespaceWidth
        let height = ascent + descent + leading
        return TypeBounds(width: width, ascent: ascent, descent: descent, leading: leading, height: height)
    }()

    public var width: CGFloat { return typeBounds.width }
    public var ascent: CGFloat { return typeBounds.ascent }
    public var descent: CGFloat { return typeBounds.descent }
    public var leading: CGFloat { return typeBounds.leading }
    public var height: CGFloat { return typeBounds.height }

    public init(ctLine: CTLine) {
        self.ctLine = ctLine
    }

    public private(set) lazy var runs: [TypeRun] = {
        let r = CTLineGetGlyphRuns(ctLine) as! [CTRun]
        return r.map { TypeRun(ctRun: $0) }
    }()

    public private(set) lazy var glyphCount: Int = CTLineGetGlyphCount(ctLine)
}

extension TypeLine: CustomStringConvertible {
    public var description: String {
        return "(TypeLine width: \(width), ascent: \(ascent), descent: \(descent), leading \(leading))"
    }
}
