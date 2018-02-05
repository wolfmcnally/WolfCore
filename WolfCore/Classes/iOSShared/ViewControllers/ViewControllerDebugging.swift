//
//  ViewControllerDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/18/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UIViewController {
    public func printControllerHierarchy() {
        let aliaser = ObjectAliaser()
        var stack = [(controller: UIViewController, level: Int, indent: String)]()
        
        stack.append((self, 0, ""))
        let frontController = UIViewController.frontViewController
        
        repeat {
            let (controller, level, indent) = stack.removeLast()
            
            let joiner = Joiner()
            
            joiner.append(prefix(for: controller, frontController: frontController))
            
            controller.childViewControllers.reversed().forEach { childController in
                stack.append((childController, level + 1, indent + "  |"))
            }
            
            joiner.append( indent, "\(level)".padded(to: 2) )
            joiner.append(aliaser.name(for: controller))
            
            if let view = controller.viewIfLoaded {
                joiner.append("view: \(view)")
            } else {
                joiner.append("view: nil")
            }
            
            if let presentedViewController = controller.presentedViewController {
                if presentedViewController != controller.parent?.presentedViewController {
                    stack.insert((presentedViewController, 0, ""), at: 0)
                    joiner.append("presents:\(aliaser.name(for: presentedViewController))")
                }
            }
            
            if let presentingViewController = controller.presentingViewController {
                if presentingViewController != controller.parent?.presentingViewController {
                    joiner.append("presentedBy:\(aliaser.name(for: presentingViewController))")
                }
            }
            
            print(joiner)
        } while !stack.isEmpty
    }
    
    private func prefix(for controller: UIViewController, frontController: UIViewController) -> String {
        var prefix: String!
        
        if prefix == nil {
            for window in UIApplication.shared.windows {
                if let rootViewController = window.rootViewController {
                    if controller == rootViewController {
                        prefix = "🌳"
                    }
                }
            }
        }
        
        if prefix == nil {
            if let presentingViewController = controller.presentingViewController {
                if presentingViewController != controller.parent?.presentingViewController {
                    prefix = "🎁"
                }
            }
        }
        
        if prefix == nil {
            prefix = "⬜️"
        }
        
        prefix = prefix! + (controller == frontController ? "🔵" : "⬜️")
        
        return prefix
    }
}

public func printRootControllerHierarchy() {
    UIApplication.shared.windows[0].rootViewController?.printControllerHierarchy()
}
