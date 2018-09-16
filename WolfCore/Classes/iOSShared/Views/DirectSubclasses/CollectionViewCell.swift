//
//  CollectionViewCell.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/27/16.
//  Copyright © 2016 WolfMcNally.com.
//

import UIKit

open class CollectionViewCell: UICollectionViewCell {
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

        // https://stackoverflow.com/questions/24750158/autoresizing-issue-of-uicollectionviewcell-contentviews-frame-in-storyboard-pro
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        setup()
    }

    open func setup() { }
}
