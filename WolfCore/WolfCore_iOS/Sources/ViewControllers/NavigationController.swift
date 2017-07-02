//
//  NavigationController.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class NavigationController: UINavigationController, UINavigationControllerDelegate, Skinnable {
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
  }
  
  public var onWillShow: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
  public var onDidShow: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
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
    blurEffect.update()
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
    blurEffect = NavigationBarBlurEffect(navigationController: self)
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //        if let visibleViewController = visibleViewController {
    //            skin = visibleViewController.skin
    //        }
  }
  
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    let child = topViewController
    logTrace("statusBarStyle redirect to \(child†)", obj: self, group: .statusBar)
    return child
  }
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return _preferredStatusBarStyle(for: skin)
  }
  
  open func setup() { }
  
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    
    skin = viewController.skin
    
    onWillShow?(navigationController, animated)
  }
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    
    onDidShow?(navigationController, animated)
  }
}
