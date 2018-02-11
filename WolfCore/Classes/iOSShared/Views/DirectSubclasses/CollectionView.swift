//
//  CollectionView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/18.
//

import UIKit

open class CollectionView: UICollectionView {
    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(collectionViewLayout layout: UICollectionViewLayout) {
        self.init(frame: .zero, collectionViewLayout: layout)
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
