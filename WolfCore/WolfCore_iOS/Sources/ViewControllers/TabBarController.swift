//
//  TabBarController.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class TabBarController: UITabBarController, Skinnable {
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    _setup()
  }
  
  private func _setup() {
    logInfo("init \(self)", group: .viewControllerLifecycle)
    setup()
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
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    propagateSkin(why: "viewWillAppear")
  }
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return _preferredStatusBarStyle(for: skin)
  }
  
  open func setup() { }
}
