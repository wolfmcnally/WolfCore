//
//  TableView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/14/17.
//  Copyright © 2017 WolfMcNally.com.
//

import UIKit

open class TableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .plain)
    }

    public convenience init(style: UITableView.Style) {
        self.init(frame: .zero, style: style)
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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

    public func deselectAll(animated: Bool) {
        guard let selectedIndexPaths = indexPathsForSelectedRows else { return }
        for indexPath in selectedIndexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }
}
