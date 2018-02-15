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
}
