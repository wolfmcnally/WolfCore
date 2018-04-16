//
//  SegmentedControl.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/15/18.
//

import UIKit

open class SegmentedControl: UISegmentedControl {
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
        syncFont()
        setup()
    }

    open func setup() { }

    public var titleFont: UIFont? {
        didSet { syncFont() }
    }

    @IBInspectable
    public var segmentPadding: CGSize = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    @IBInspectable
    public var titleFontName: String? {
        didSet { syncFont() }
    }

    #if os(iOS)
    @IBInspectable
    public var titleFontSize: CGFloat = UIFont.systemFontSize {
        didSet { syncFont() }
    }
    #elseif os(tvOS)
    public var titleFontSize: CGFloat = 14 {
        didSet { syncFont() }
    }
    #endif

    #if TARGET_INTERFACE_BUILDER

    public override func prepareForInterfaceBuilder() {
        setup()
    }

    #endif

    private var effectiveFont: UIFont {
        if let titleFont = titleFont {
            return titleFont
        } else if let fontName = titleFontName, let titleFont = UIFont(name: fontName, size: titleFontSize) {
            return titleFont
        } else {
            return .systemFont(ofSize: titleFontSize)
        }
    }

    private func syncFont() {
        let attributes: StringAttributes = [.font: effectiveFont]
        setTitleTextAttributes(attributes, for: [])
        setNeedsLayout()
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        size.height += floor(2 * segmentPadding.height)
        size.width += segmentPadding.width * CGFloat(numberOfSegments + 1)

        return size
    }
}
