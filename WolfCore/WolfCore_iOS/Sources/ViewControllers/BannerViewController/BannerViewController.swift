//
//  BannerViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/19/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public let bulletinViewRegistry = BulletinViewRegistry()

public class BulletinViewRegistry {
  private var viewTypesForBulletinTypes = [ObjectIdentifier: (Bulletin) -> BulletinViewProtocol]()

  public func register(bulletinType: Bulletin.Type, viewCreator: @escaping (Bulletin) -> BulletinViewProtocol) {
    let oid = ObjectIdentifier(bulletinType)
    viewTypesForBulletinTypes[oid] = viewCreator
  }

  public func unregister(bulletinType: Bulletin.Type) {
    let oid = ObjectIdentifier(bulletinType)
    viewTypesForBulletinTypes[oid] = nil
  }

  fileprivate init() {
    register(bulletinType: MessageBulletin.self) {
      return MessageBulletinView(model: $0 as! MessageBulletin)
    }

    register(bulletinType: ReachabilityBulletin.self) {
      return ReachabilityBulletinView(model: $0 as! ReachabilityBulletin)
    }
  }

  public func newViewForBulletin(_ bulletin: Bulletin) -> BulletinViewProtocol {
    let bulletinType = type(of: bulletin)
    let oid = ObjectIdentifier(bulletinType)
    guard let creator = viewTypesForBulletinTypes[oid] else {
      fatalError("No registered view for \(bulletinType)")
    }
    let view = creator(bulletin)
    view.bulletin = bulletin
    return view
  }
}

open class BannerViewController: ViewController {
  // For embedding from within Interface Builder
  @IBOutlet var contentViewContainer: View!
  
  public enum PresentationStyle {
    case overlayBulletinViews
    case compressMainView
  }
  
  private var subscriber = BulletinSubscriber()
  
  private var bannersContainerHeightConstraint = Constraints()
  private var presentationStyle: PresentationStyle! = .compressMainView
  private var maxBannersVisible: Int! = 5
  
  open override func setup() {
    super.setup()
    
    subscriber.onAddedItem = { [unowned self] item in
      self.addView(for: item)
    }
    
    subscriber.onRemovedItem = { [unowned self] item in
      self.removeView(for: item)
    }
  }
  
  public init(presentationStyle: PresentationStyle = .compressMainView, maxBannersVisible: Int = 1) {
    super.init(nibName: nil, bundle: nil)
    self.presentationStyle = presentationStyle
    self.maxBannersVisible = maxBannersVisible
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func subscribe(to publisher: BulletinPublisher) {
    subscriber.subscribe(to: publisher)
  }
  
  public func unsubscribe(from publisher: BulletinPublisher) {
    subscriber.unsubscribe(from: publisher)
  }
  
  private func addView(for bulletin: Bulletin) {
    addBulletinView(bulletinViewRegistry.newViewForBulletin(bulletin))
  }
  
  private func addBulletinView(_ bulletinView: BulletinViewProtocol) {
    bannersView.addBulletinView(bulletinView, animated: true) {
      self.syncToVisibleBanners()
    }
  }
  
  private func removeView(for bulletin: Bulletin) {
    bannersView.removeView(for: bulletin, animated: true) {
      self.syncToVisibleBanners()
    }
  }
  
  private func removeContentViewController() {
    guard let existingContentViewController = contentViewController else { return }
    existingContentViewController.willMove(toParentViewController: nil)
    existingContentViewController.removeFromParentViewController()
    existingContentViewController.view.removeFromSuperview()
  }
  
  private func getContentViewController() -> UIViewController? {
    return contentViewContainer?.subviews.first?.viewController
  }
  
  private func setContentViewController(to newViewController: UIViewController?) {
    guard let newContentViewController = newViewController else { return }
    
    let newView = newContentViewController.view!
    newView.translatesAutoresizingMaskIntoConstraints = false
    addChildViewController(newContentViewController)
    contentViewContainer => [
      newView
    ]
    newView.constrainFrameToFrame(of: contentViewContainer)
    setNeedsStatusBarAppearanceUpdate()
  }
  
  private func replaceContentViewController(with newViewController: UIViewController?, animated: Bool = true) -> SuccessPromise {
    var animated = animated
    var snapshotImageView: UIImageView!
    
    if let contentViewController = contentViewController, contentViewController.isViewLoaded {
      snapshotImageView = UIImageView(image: contentViewController.view.snapshot())
      contentViewContainer.addSubview(snapshotImageView)
    } else {
      animated = false
    }
    
    func perform(promise: SuccessPromise) {
      func animateTransition() {
        removeContentViewController()
        setContentViewController(to: newViewController)
        if animated {
          contentViewContainer.bringSubview(toFront: snapshotImageView)
          dispatchAnimated {
            snapshotImageView.alpha = 0
            }.then { _ in
              snapshotImageView.removeFromSuperview()
              promise.keep(())
            }.run()
        } else {
          promise.keep(())
        }
      }
      
      if let presentedViewController = contentViewController?.presentedViewController {
        presentedViewController.dismiss(animated: false) {
          animateTransition()
        }
      } else {
        animateTransition()
      }
    }
    
    return SuccessPromise(with: perform)
  }
  
  public var contentViewController: UIViewController? {
    get {
      return getContentViewController()
    }
    
    set {
      replaceContentViewController(with: newValue, animated: false).run()
    }
  }
  
  open override var childViewControllerForStatusBarHidden: UIViewController? {
    return contentViewController
  }
  
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    if hasVisibleBanners {
      return nil
    } else {
      return contentViewController
    }
  }
  
  private var bannersContainerTopConstraint = Constraints()
  
  private var hasVisibleBanners = false
  
  private func syncToVisibleBanners() {
    let heightForBanners = bannersView.heightForBanners(count: maxBannersVisible)
    bannersContainerHeightConstraint.constant = heightForBanners
    if heightForBanners > 0 {
      if #available(iOS 11.0, *) {
        bannersContainerTopConstraint ◊= Constraints(bannersView.topAnchor == view.safeAreaLayoutGuide.topAnchor)
      } else {
        bannersContainerTopConstraint ◊= Constraints(bannersView.topAnchor == topLayoutGuide.bottomAnchor)
      }
      hasVisibleBanners = true
    } else {
      bannersContainerTopConstraint ◊= Constraints(bannersView.topAnchor == view.topAnchor)
      hasVisibleBanners = false
    }
    view.layoutIfNeeded()
    setNeedsStatusBarAppearanceUpdate()
  }
  
  private lazy var bannersView: BannersView = .init()
  
  open override func build() {
    super.build()
    
    // If was not added by Interface Builder
    if contentViewContainer == nil {
      contentViewContainer = View()
    }
    
    view => [
      contentViewContainer,
      bannersView
    ]
    
    bannersContainerTopConstraint = Constraints(bannersView.topAnchor == view.topAnchor)
    bannersContainerHeightConstraint = Constraints(bannersView.heightAnchor == 0)
    
    Constraints(
      bannersView.leadingAnchor == view.leadingAnchor,
      bannersView.trailingAnchor == view.trailingAnchor,
      
      contentViewContainer.leadingAnchor == view.leadingAnchor,
      contentViewContainer.trailingAnchor == view.trailingAnchor,
      contentViewContainer.bottomAnchor == view.bottomAnchor
    )
    
    switch presentationStyle! {
    case .compressMainView:
      Constraints(
        contentViewContainer.topAnchor == bannersView.bottomAnchor
      )
    case .overlayBulletinViews:
      Constraints(
        contentViewContainer.topAnchor == view.topAnchor
      )
    }
  }
}
