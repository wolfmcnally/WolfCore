//
//  PagingViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/19/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class PagingViewController: ViewController {
  @IBOutlet public weak var bottomView: UIView!
  
  override open func reviseSkin(_ skin: Skin) -> Skin? {
    return skinForCurrentPage()
  }
  
  func skinForPage(_ index: Int) -> Skin {
    guard (0..<pagedViewControllers.count).contains(index) else { return skin }
    return pagedViewControllers[index].skin!
  }
  
  func skinForCurrentPage() -> Skin {
    return skinForPage(pagingView.currentPage)
  }
  
  public private(set) lazy var pagingView: PagingView = {
    let view = PagingView()
    view.hidesPagingControlForOnePage = true
    return view
  }()
  
  private var bottomViewToPageControlConstraint: NSLayoutConstraint!
  
  open override func setup() {
    super.setup()
    automaticallyAdjustsScrollViewInsets = false
    pagingView.onDidLayout = { [unowned self] (fromIndex, toIndex, frac) in
      self.didLayoutPagingView(fromIndex: fromIndex, toIndex: toIndex, frac: frac)
    }
  }
  
  public func skinForPaging(fromIndex: Int, toIndex: Int, frac: Frac) -> Skin {
    guard (0..<pagedViewControllers.count).contains(fromIndex) else { return skin }
    let fromController = pagedViewControllers[fromIndex]
    let fromSkin = fromController.skin!
    let targetSkin: Skin
    if frac == 0.0 {
      targetSkin = fromSkin
    } else {
      let toController = pagedViewControllers[toIndex]
      let toSkin = toController.skin!
      targetSkin = fromSkin.interpolated(to: toSkin, at: frac)
    }
    return targetSkin
  }
  
  open func didLayoutPagingView(fromIndex: Int, toIndex: Int, frac: Frac) {
    let pagingSkin = skinForPaging(fromIndex: fromIndex, toIndex: toIndex, frac: frac)
    navigationController?.skin = pagingSkin
    view.skin = pagingSkin
  }
  
  public var pagedViewControllers: [UIViewController]! {
    didSet {
      pagingView.arrangedViews = []
      for viewController in childViewControllers {
        viewController.removeFromParentViewController()
      }
      var pageViews = [UIView]()
      for viewController in pagedViewControllers {
        addChildViewController(viewController)
        pageViews.append(viewController.view)
      }
      pagingView.arrangedViews = pageViews
    }
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    view.insertSubview(pagingView, at: 0)
    pagingView.constrainFrameToFrame()
    
    if let bottomView = bottomView {
      bottomViewToPageControlConstraint = pagingView.pageControl.bottomAnchor == bottomView.topAnchor - 20
      bottomViewToPageControlConstraint.isActive = true
    }
  }
  
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    guard pagingView.pageControl.numberOfPages == pagedViewControllers?.count else { return nil }
    let currentPage = pagingView.currentPage
    guard (0..<pagedViewControllers.count).contains(currentPage) else { return nil }
    let child = pagedViewControllers?[currentPage]
    logTrace("statusBarStyle redirect to \(child†)", obj: self, group: .statusBar)
    return child
  }
}
