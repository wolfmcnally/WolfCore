//
//  ViewExtensions-iOS.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/3/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import UIKit

#if !os(tvOS)
    extension UIView {
        public func isTransparentToTouch(at point: CGPoint, with event: UIEvent?) -> Bool {
            for subview in subviews {
                if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                    return true
                }
            }
            return false
        }
    }
#else
    extension UIView {
        public func isTransparentToTouch(at point: CGPoint, with event: UIEvent?) -> Bool {
            return self.point(inside: point, with: event)
        }
    }
#endif

extension UIView {
    public func setBorder(cornerRadius radius: CGFloat? = nil, width: CGFloat? = nil, color: UIColor? = nil) {
        if let radius = radius { layer.cornerRadius = radius }
        if let width = width { layer.borderWidth = width }
        if let color = color { layer.borderColor = color.cgColor }
    }
}

#if !os(tvOS)
    extension UIView {
        public var statusBarFrame: CGRect? {
            guard let window = window else { return nil }
            let statusBarFrame = UIApplication.shared.statusBarFrame
            let statusBarWindowRect = window.convert(statusBarFrame, from: nil)
            let statusBarViewRect = convert(statusBarWindowRect, from: nil)
            return statusBarViewRect
        }
    }
#endif

extension UIView {
    public func snapshot(afterScreenUpdates: Bool = false) -> UIImage {
        return newImage(withSize: bounds.size) { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}

private struct AssociatedKeys {
    static var endEditingGestureRecognizerAction = "WolfCore_endEditingTapGestureRecognizerAction"
}

extension UIView {
    private var endEditingAction: GestureRecognizerAction? {
        get {
            return getAssociatedValue(for: &AssociatedKeys.endEditingGestureRecognizerAction)
        }

        set {
            setAssociatedValue(newValue, for: &AssociatedKeys.endEditingGestureRecognizerAction)
        }
    }

    public var endsEditingWhenTapped: Bool {
        get {
            return endEditingAction != nil
        }

        set {
            guard newValue != (endEditingAction != nil) else { return }
            if newValue {
                let tapGestureRecognizer = UITapGestureRecognizer()
                tapGestureRecognizer.cancelsTouchesInView = false
                endEditingAction = addAction(for: tapGestureRecognizer) { [unowned self] _ in
                    self.window?.endEditing(false)
                }
                endEditingAction!.shouldReceiveTouch = { touch in
                    return !(touch.view is UIControl)
                }
            } else {
                endEditingAction = nil
            }
        }
    }
}
