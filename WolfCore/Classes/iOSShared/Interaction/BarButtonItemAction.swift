//
//  BarButtonAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/18/16.
//  Copyright © 2016 WolfMcNally.com.
//

import UIKit

private let barButtonActionSelector = #selector(BarButtonItemAction.itemAction)

public class BarButtonItemAction: NSObject {
    public var action: Block?
    public let item: UIBarButtonItem

    public init(item: UIBarButtonItem, action: Block? = nil) {
        self.item = item
        self.action = action
        super.init()
        item.target = self
        item.action = barButtonActionSelector
    }

    @objc public func itemAction() {
        action?()
    }
}

extension UIBarButtonItem {
    public func addAction(action: @escaping Block) -> BarButtonItemAction {
        return BarButtonItemAction(item: self, action: action)
    }
}

extension UIBarButtonItem {
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }

    public convenience init(title: String, style: UIBarButtonItem.Style = .plain) {
        self.init(title: title, style: style, target: nil, action: nil)
    }
}
