//
//  TableViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/27/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UITableView {
    public func register(nibName name: String, in bundle: Bundle? = nil, forCellReuseIdentifier identifier: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: identifier)
    }

    public func setupDynamicRowHeights(withEstimatedRowHeight estimatedRowHeight: CGFloat) {
        rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = estimatedRowHeight
    }

    public func syncDynamicContent(of cell: UITableViewCell, animated: Bool = true, scrollingToVisibleAt indexPath: IndexPath? = nil, with updates: @escaping Block) {
        dispatchAnimated(animated) {
            updates()
            }.run()
        dispatchAnimated(animated) {
            self.beginUpdates()
            cell.updateConstraintsIfNeeded()
            cell.layoutIfNeeded()
            self.endUpdates()
            guard let indexPath = indexPath else { return }
            let cellFrame = self.rectForRow(at: indexPath)
            self.scrollRectToVisible(cellFrame, animated: animated)
            }.run()
    }

    public func performUpdates(using block: Block) {
        beginUpdates()
        block()
        endUpdates()
    }
}
