//
//  TextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/1/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

open class TextField: UITextField {
    var tintedClearImage: UIImage?
    var lastTintColor: UIColor?
    public static var placeholderColor: UIColor?
    var placeholderColor: UIColor?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() {
    }

    public var plainText: String {
        get {
            return text ?? ""
        }

        set {
            text = newValue
        }
    }
}
