//
//  VerticalStackView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

open class VerticalStackView: StackView {
    open override func setup() {
        super.setup()
        axis = .vertical
    }
}
