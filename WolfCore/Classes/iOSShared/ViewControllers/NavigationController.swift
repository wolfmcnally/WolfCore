//
//  NavigationController.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com.
//

import UIKit
import WolfLog

open class NavigationController: UINavigationController, UINavigationControllerDelegate {
    public var onWillShow: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    public var onDidShow: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    #if !os(tvOS)
    private var blurEffect: NavigationBarBlurEffect!

    var isBlurred = true {
        didSet {
            if isBlurred {
                blurEffect.show()
            } else {
                blurEffect.hide()
            }
        }
    }
    #endif

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _setup()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        _setup()
    }

    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        _setup()
    }

    private func _setup() {
        logInfo("init \(self)", group: .viewControllerLifecycle)
        delegate = self
        setup()
    }

    private var effectView: UIVisualEffectView!
    private var navbarBlurTopConstraint: NSLayoutConstraint!

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        #if !os(tvOS)
        blurEffect.update()
        #endif
    }

    deinit {
        logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.debugIdentifier = "\(typeName(of: self)).view"
        #if !os(tvOS)
        blurEffect = NavigationBarBlurEffect(navigationController: self)
        #endif
    }

    open func setup() { }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        onWillShow?(navigationController, animated)
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        onDidShow?(navigationController, animated)
    }
}
