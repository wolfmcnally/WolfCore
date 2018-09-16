//
//  ControlAction.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 WolfMcNally.com.
//

import UIKit
import WolfStrings

private let controlActionSelector = #selector(ControlAction.controlAction)

open class ControlAction<C: UIControl>: NSObject {
    public typealias ControlType = C
    public typealias ResponseBlock = (ControlType) -> Void

    public var action: ResponseBlock?
    public let control: ControlType
    private let controlEvents: UIControl.Event

    public init(control: ControlType, for controlEvents: UIControl.Event, action: ResponseBlock? = nil) {
        self.control = control
        self.action = action
        self.controlEvents = controlEvents
        super.init()
        control.addTarget(self, action: controlActionSelector, for: controlEvents)
    }

    deinit {
        control.removeTarget(self, action: controlActionSelector, for: controlEvents)
    }

    @objc public func controlAction() {
        action?(control)
    }
}

public func addControlAction<ControlType>(to control: ControlType, for controlEvents: UIControl.Event, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return ControlAction(control: control, for: controlEvents, action: action)
}

public func addTouchUpInsideAction<ControlType>(to control: ControlType, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return addControlAction(to: control, for: .touchUpInside, action: action)
}

public func addValueChangedAction<ControlType>(to control: ControlType, action: ControlAction<ControlType>.ResponseBlock? = nil) -> ControlAction<ControlType> {
    return addControlAction(to: control, for: .valueChanged, action: action)
}


public typealias RefreshBlock = (_ completion: @escaping (_ endText: AttributedString?) -> Void) -> AttributedString?

// Example RefreshBlock that shows the refresh control for 3:
//
//        onRefresh = { completion in
//            dispatchOnMain(afterDelay: 3.0) {
//                completion("Done"§)
//            }
//            return ("Started..."§)
//        }

#if !os(tvOS)
    @available(iOS 10.0, *)
    public class RefreshControlAction: ControlAction<UIRefreshControl> {
        public let scrollView: UIScrollView
        public init(scrollView: UIScrollView, refreshAction: @escaping RefreshBlock) {
            self.scrollView = scrollView
            guard scrollView.refreshControl == nil else {
                fatalError("Scroll view may not already have a refresh control.")
            }
            scrollView.refreshControl = UIRefreshControl()
            super.init(control: scrollView.refreshControl!, for: .valueChanged) { refreshControl in
                let startTitle = refreshAction { endTitle in
                    dispatchOnMain {
                        refreshControl.attributedTitle = endTitle
                        refreshControl.endRefreshing()
                    }
                }
                refreshControl.attributedTitle = startTitle
            }
        }

        deinit {
            scrollView.refreshControl = nil
        }
    }

    @available(iOS 10.0, *)
    public func addRefreshControlAction(to scrollView: UIScrollView, action: @escaping RefreshBlock) -> RefreshControlAction {
        return RefreshControlAction(scrollView: scrollView, refreshAction: action)
    }

#endif
