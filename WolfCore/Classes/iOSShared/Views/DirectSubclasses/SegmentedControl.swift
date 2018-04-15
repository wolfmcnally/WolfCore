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
        setupFont()
        setup()
    }

    open func setup() { }

    var titleFont: UIFont?

    @IBInspectable
    var segmentPadding: CGSize = .zero

    @IBInspectable
    var titleFontName: String?

    @IBInspectable
    var titleFontSize: CGFloat = UIFont.systemFontSize

    #if TARGET_INTERFACE_BUILDER

    override func prepareForInterfaceBuilder() {
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

    private func setupFont() {
        let attributes: StringAttributes = [.font: effectiveFont]
        setTitleTextAttributes(attributes, for: [])
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        size.height += floor(2 * segmentPadding.height)
        size.width += segmentPadding.width * CGFloat(numberOfSegments + 1)

        return size
    }
}
