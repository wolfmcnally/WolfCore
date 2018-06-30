//
//  NavigationBarExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UINavigationBar {
    public func setAppearance(barTintColor: UIColor?, tintColor: UIColor?, titleColor: UIColor?) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        var titleTextAttributes = [NSAttributedString.Key: AnyObject]()
        if let titleColor = titleColor {
            titleTextAttributes[.foregroundColor] = titleColor
        }
        self.titleTextAttributes = titleTextAttributes
    }
}
