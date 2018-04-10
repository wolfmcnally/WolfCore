//
//  ViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//


import UIKit

public typealias ViewControllerBlock = (UIViewController) -> Void

extension LogGroup {
    public static let viewControllerLifecycle = LogGroup("viewControllers")
}

open class ViewController: UIViewController {
    open var navigationItemTitleView: UIView? { return nil }

    public private(set) lazy var activityOverlayView: ActivityOverlayView = {
        let activityView = ActivityOverlayView()
        self.view => [
            activityView
        ]
        activityView.constrainFrameToFrame(priority: .defaultLow)
        return activityView
    }()

    public func newActivity() -> LockerCause {
        return activityOverlayView.newActivity()
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
        //logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.debugIdentifier = "\(typeName(of: self)).view"
        build()
        #if !os(tvOS)
            setupNavBarActions()
        #endif
    }

    open func build() {
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.titleView == nil {
            if let navigationItemTitleView = navigationItemTitleView {
                navigationItem.titleView = navigationItemTitleView
            }
        }
    }

    open override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
    }

    open func setup() { }

    #if !os(tvOS)
    public var leftItemAction: BarButtonItemAction? {
    didSet {
    navigationItem.leftBarButtonItem = leftItemAction?.item
    }
    }

    public var rightItemAction: BarButtonItemAction? {
    didSet {
    navigationItem.rightBarButtonItem = rightItemAction?.item
    }
    }

    private func setupNavBarActions() {
    if let leftItemAction = newLeftItemAction() {
    self.leftItemAction = leftItemAction
    }

    if let rightItemAction = newRightItemAction() {
    self.rightItemAction = rightItemAction
    }
    }

    open func newLeftItemAction() -> BarButtonItemAction? {
    return nil
    }

    open func newRightItemAction() -> BarButtonItemAction? {
    return nil
    }
    #endif
}
