//
//  TypeRun.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/20/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreText

public class TypeRun {
    private let ctRun: CTRun

    public init(ctRun: CTRun) {
        self.ctRun = ctRun
    }

    public private(set) lazy var glyphCount = CTRunGetGlyphCount(ctRun)

    public func typeBounds(in range: Range<Int>) -> TypeBounds {
        let cfRange = CFRange(range: range)
        var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
        let width = CGFloat(CTRunGetTypographicBounds(ctRun, cfRange, &ascent, &descent, &leading))
        let height = ascent + descent + leading
        return TypeBounds(width: width, ascent: ascent, descent: descent, leading: leading, height: height)
    }

    public func typeBounds(at glyphIndex: Int) -> TypeBounds {
        return typeBounds(in: glyphIndex ..< (glyphIndex + 1))
    }

    public func widthOfGlyph(at glyphIndex: CFIndex) -> CGFloat {
        let cfRange = CFRange(location: glyphIndex, length: 1)
        return CGFloat(CTRunGetTypographicBounds(ctRun, cfRange, nil, nil, nil))
    }

    public func draw(into context: CGContext, range: Range<Int>, at point: CGPoint? = nil) {
        drawInto(context) { context in
            let cfRange = CFRange(range: range)
            CTRunDraw(ctRun, context, cfRange)
        }
    }

    public func draw(into context: CGContext, index: Int, at point: CGPoint? = nil) {
        draw(into: context, range: index ..< (index + 1), at: point)
    }

    public var textMatrix: CGAffineTransform {
        return CTRunGetTextMatrix(ctRun)
    }

    public func makeTextMatrix(for point: CGPoint) -> CGAffineTransform {
        return textMatrix •• {
            $0.tx = point.x
            $0.ty = point.y
        }
    }

    public func imageBounds(in context: CGContext, range: Range<Int>) -> CGRect {
        let cfRange = CFRange(range: range)
        return CTRunGetImageBounds(ctRun, context, cfRange)
    }

    public func imageBounds(in context: CGContext, glyphIndex: Int) -> CGRect {
        return imageBounds(in: context, range: glyphIndex ..< (glyphIndex + 1))
    }
}
