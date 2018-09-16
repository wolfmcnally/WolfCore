//
//  HorizontalStackView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com.
//

open class HorizontalStackView: StackView {
    open override func setup() {
        super.setup()
        axis = .horizontal
    }
}
