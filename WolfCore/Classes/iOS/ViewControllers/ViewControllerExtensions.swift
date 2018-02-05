//
//  ViewControllerExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UIViewController {
    public func presentModal(from presentingViewController: UIViewController) -> Self {
        let navigationController = NavigationController(rootViewController: self)
        presentingViewController.present(navigationController, animated: true)
        return self
    }
}

extension UIViewController {
    public func newCancelDismissAction(onCancel: Block? = nil) -> BarButtonItemAction {
        return BarButtonItemAction(item: UIBarButtonItem(barButtonSystemItem: .cancel)) { [unowned self] in
            onCancel?()
            self.dismiss()
        }
    }
    
    public func newDoneDismissAction(onDone: Block? = nil) -> BarButtonItemAction {
        return BarButtonItemAction(item: UIBarButtonItem(barButtonSystemItem: .done)) { [unowned self] in
            onDone?()
            self.dismiss()
        }
    }
    
    @objc open func dismiss(completion: Block?) {
        dismiss(animated: true, completion: completion)
    }
    
    @objc open func dismiss() {
        dismiss(completion: nil)
    }
    
    public func setBackButtonText(to text: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
    }
    
    public func removeBackButtonText() {
        setBackButtonText(to: "")
    }
}

public typealias AlertActionBlock = (UIAlertAction) -> Void

public struct AlertAction {
    public let title: String
    public let style: UIAlertActionStyle
    public let identifier: String?
    public let handler: AlertActionBlock?
    
    public init(title: String, style: UIAlertActionStyle = .default, identifier: String? = nil, handler: AlertActionBlock? = nil) {
        self.title = title
        self.style = style
        self.identifier = identifier
        self.handler = handler
    }
    
    public static func newCancelAction(handler: AlertActionBlock? = nil) -> AlertAction {
        return AlertAction(title: "Cancel"¶, style: .cancel, identifier: "cancel", handler: handler)
    }
    
    public static func newOKAction(handler: AlertActionBlock? = nil) -> AlertAction {
        return AlertAction(title: "OK"¶, identifier: "ok", handler: handler)
    }
}

extension UIViewController {
    public func present(alertController: UIAlertController, animated: Bool = true, withIdentifier identifier: String? = nil, buttonIdentifiers: [String?], didAppear: Block? = nil) {
        alertController.view.accessibilityIdentifier = identifier
        present(alertController, animated: animated, completion: didAppear)
        RunLoop.current.runOnce()
        for i in 0..<buttonIdentifiers.count {
            alertController.setAction(identifier: buttonIdentifiers[i], at: i)
        }
    }
    
    private func presentAlertController(withPreferredStyle style: UIAlertControllerStyle, title: String?, message: String?, identifier: String? = nil, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .any, actions: [AlertAction], didAppear: Block?, didDisappear: Block?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if popoverSourceView != nil || popoverSourceRect != nil || popoverBarButtonItem != nil {
            if let popover = alert.popoverPresentationController {
                if let popoverSourceView = popoverSourceView {
                    popover.sourceView = popoverSourceView
                    if let popoverSourceRect = popoverSourceRect {
                        popover.sourceRect = popoverSourceRect
                    } else {
                        popover.sourceRect = popoverSourceView.bounds
                    }
                } else if let popoverBarButtonItem = popoverBarButtonItem {
                    popover.barButtonItem = popoverBarButtonItem
                }
                popover.permittedArrowDirections = popoverPermittedArrowDirections
            }
        }
        var buttonIdentifiers = [String?]()
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { alertAction in
                didDisappear?()
                action.handler?(alertAction)
            }
            )
            buttonIdentifiers.append(action.identifier)
            alert.addAction(alertAction)
        }
        present(alertController: alert, withIdentifier: identifier, buttonIdentifiers: buttonIdentifiers, didAppear: didAppear)
    }
    
    public func presentAlert(withTitle title: String, message: String? = nil, identifier: String? = nil, actions: [AlertAction], didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlertController(withPreferredStyle: .alert, title: title, message: message, identifier: identifier, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentAlert(withMessage message: String, identifier: String? = nil, actions: [AlertAction], didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlertController(withPreferredStyle: .alert, title: nil, message: message, identifier: identifier, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentSheet(withTitle title: String? = nil, message: String? = nil, identifier: String? = nil, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, popoverBarButtonItem: UIBarButtonItem? = nil, popoverPermittedArrowDirections: UIPopoverArrowDirection = .any, actions: [AlertAction], didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlertController(withPreferredStyle: .actionSheet, title: title, message: message, identifier: identifier, popoverSourceView: popoverSourceView, popoverSourceRect: popoverSourceRect, popoverBarButtonItem: popoverBarButtonItem, popoverPermittedArrowDirections: popoverPermittedArrowDirections, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentOKAlert(withTitle title: String, message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlert(withTitle: title, message: message, identifier: identifier, actions: [AlertAction.newOKAction()], didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentOKAlert(withMessage message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlert(withMessage: message, identifier: identifier, actions: [AlertAction.newOKAction()], didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentAlert(forError errorType: Error, withTitle title: String, message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        logError(errorType)
        presentOKAlert(withTitle: title, message: message, identifier: identifier, didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentAlert(forError errorType: Error, withMessage message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        logError(errorType)
        presentOKAlert(withMessage: message, identifier: identifier, didAppear: didAppear, didDisappear: didDisappear)
    }
    
    public func presentAlert(forError errorType: Error, didAppear: Block? = nil, didDisappear: Block? = nil) {
        switch errorType {
        case let error as DescriptiveError:
            presentAlert(forError: error, withMessage: error.message, identifier: error.identifier, didAppear: didAppear, didDisappear: didDisappear)
        case let error as LocalizedError:
            presentAlert(forError: error, withMessage: error.localizedDescription, didAppear: didAppear, didDisappear: didDisappear)
        default:
            presentAlert(forError: errorType, withTitle: "Something Went Wrong"¶, message: "Please try again later."¶, identifier: "error", didAppear: didAppear, didDisappear: didDisappear)
        }
    }
}

public protocol HasFrontViewController {
    var frontViewController: UIViewController { get }
}

extension UINavigationController: HasFrontViewController {
    public var frontViewController: UIViewController {
        return topViewController!
    }
}

extension UITabBarController: HasFrontViewController {
    public var frontViewController: UIViewController {
        return selectedViewController!
    }
}

extension UIViewController {
    public static var frontViewController: UIViewController {
        let windowRootController = UIApplication.shared.windows[0].rootViewController!
        var front = windowRootController.presentedViewController ?? windowRootController
        var lastFront: UIViewController? = nil
        
        while front != lastFront {
            guard let front2 = front as? HasFrontViewController else { break }
            lastFront = front
            front = front2.frontViewController
            front = front.presentedViewController ?? front
        }
        
        return front
    }
}
