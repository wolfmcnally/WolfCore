//
//  Button.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import UIKit

open class Button: UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(title(for: .normal)?.localized(onlyIfTagged: true), for: .normal)
    }

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

    public func setTitle(_ title: String, font: UIFont? = nil, normal: UIColor? = nil, highlighted: UIColor? = nil, disabled: UIColor? = .gray) {
        let title = title§
        if let font = font {
            title.font = font
        }
        if let normal = normal {
            title.foregroundColor = normal
            setAttributedTitle(title, for: [])
        }
        if let highlighted = highlighted {
            let title = title.mutableCopy() as! AttributedString
            title.foregroundColor = highlighted
            setAttributedTitle(title, for: [.highlighted])
        }
        if let disabled = disabled {
            let title = title.mutableCopy() as! AttributedString
            title.foregroundColor = disabled
            setAttributedTitle(title, for: [.disabled])
        }
    }
}
