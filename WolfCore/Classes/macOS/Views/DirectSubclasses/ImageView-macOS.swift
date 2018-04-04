//
//  ImageView.swift
//  WolfCore_macOS
//
//  Created by Wolf McNally on 7/18/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import AppKit

public enum ContentMode {
    private typealias `Self` = ContentMode

    case scaleToFill
    case scaleAspectFit
    case scaleAspectFill
    case redraw
    case center
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    private static let imageAlignments: [ContentMode: NSImageAlignment] = [
        .scaleToFill: .alignCenter,
        .scaleAspectFit: .alignCenter,
        .scaleAspectFill: .alignCenter,
        .redraw: .alignCenter,
        .center: .alignCenter,
        .top: .alignTop,
        .bottom: .alignBottom,
        .left: .alignLeft,
        .right: .alignRight,
        .topLeft: .alignTopLeft,
        .topRight: .alignTopRight,
        .bottomLeft: .alignBottomLeft,
        .bottomRight: .alignBottomRight
    ]

    public var imageAlignment: NSImageAlignment {
        return Self.imageAlignments[self]!
    }

    private static let imageScalings: [ContentMode: NSImageScaling] = [
        .scaleToFill: .scaleAxesIndependently,
        .scaleAspectFit: .scaleProportionallyUpOrDown,
        .scaleAspectFill: .scaleAxesIndependently,
        .redraw: .scaleNone,
        .center: .scaleNone,
        .top: .scaleNone,
        .bottom: .scaleNone,
        .left: .scaleNone,
        .right: .scaleNone,
        .topLeft: .scaleNone,
        .topRight: .scaleNone,
        .bottomLeft: .scaleNone,
        .bottomRight: .scaleNone
    ]

    public var imageScaling: NSImageScaling {
        return Self.imageScalings[self]!
    }
}

open class ImageView: NSImageView {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() { }

    public var contentMode: ContentMode {
        get {
            fatalError("not implemented")
        }

        set {
            imageScaling = newValue.imageScaling
            imageAlignment = newValue.imageAlignment
        }
    }
}
