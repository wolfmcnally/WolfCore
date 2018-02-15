//
//  CollectionViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func register(nibName name: String, in bundle: Bundle? = nil, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: name, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    public func register(nibName name: String, in bundle: Bundle? = nil, forSupplementaryViewOfKind kind: String, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: name, bundle: bundle), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}
