//
//  ResponderExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UIResponder {
    public var viewController: UIViewController? {
        var resultViewController: UIViewController?
        var responder: UIResponder! = self
        repeat {
            if let viewController = responder as? UIViewController {
                resultViewController = viewController
                break
            }
            responder = responder.next
        } while responder != nil
        return resultViewController
    }
}
