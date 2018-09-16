//
//  ApplicationNotificationActions.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/7/16.
//  Copyright © 2016 WolfMcNally.com.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

#if os(macOS)
    public class ApplicationNotificationActions: NotificationActions {
        public var willFinishLaunching: NotificationBlock? {
            get { return getAction(for: NSApplication.willFinishLaunchingNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willFinishLaunchingNotification) }
        }

        public var didFinishLaunching: NotificationBlock? {
            get { return getAction(for: NSApplication.didFinishLaunchingNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didFinishLaunchingNotification) }
        }

        public var willHide: NotificationBlock? {
            get { return getAction(for: NSApplication.willHideNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willHideNotification) }
        }

        public var didHide: NotificationBlock? {
            get { return getAction(for: NSApplication.didHideNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didHideNotification) }
        }

        public var willUnhide: NotificationBlock? {
            get { return getAction(for: NSApplication.willUnhideNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willUnhideNotification) }
        }

        public var didUnhide: NotificationBlock? {
            get { return getAction(for: NSApplication.didUnhideNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didUnhideNotification) }
        }

        public var willBecomeActive: NotificationBlock? {
            get { return getAction(for: NSApplication.willBecomeActiveNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willBecomeActiveNotification) }
        }

        public var didBecomeActive: NotificationBlock? {
            get { return getAction(for: NSApplication.didBecomeActiveNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didBecomeActiveNotification) }
        }

        public var willResignActive: NotificationBlock? {
            get { return getAction(for: NSApplication.willResignActiveNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willResignActiveNotification) }
        }

        public var didResignActive: NotificationBlock? {
            get { return getAction(for: NSApplication.didResignActiveNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didResignActiveNotification) }
        }

        public var willUpdate: NotificationBlock? {
            get { return getAction(for: NSApplication.willUpdateNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willUpdateNotification) }
        }

        public var didUpdate: NotificationBlock? {
            get { return getAction(for: NSApplication.didUpdateNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didUpdateNotification) }
        }

        public var didChangeScreenParameters: NotificationBlock? {
            get { return getAction(for: NSApplication.didChangeScreenParametersNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.didChangeScreenParametersNotification) }
        }

        public var willTerminate: NotificationBlock? {
            get { return getAction(for: NSApplication.willTerminateNotification) }
            set { setAction(using: newValue, object: nil, name: NSApplication.willTerminateNotification) }
        }
    }
#else
    public class ApplicationNotificationActions: NotificationActions {
        public var didEnterBackground: NotificationBlock? {
            get { return getAction(for: UIApplication.didEnterBackgroundNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.didEnterBackgroundNotification) }
        }

        public var willEnterForeground: NotificationBlock? {
            get { return getAction(for: UIApplication.willEnterForegroundNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.willEnterForegroundNotification) }
        }

        public var didFinishLaunching: NotificationBlock? {
            get { return getAction(for: UIApplication.didFinishLaunchingNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.didFinishLaunchingNotification) }
        }

        public var didBecomeActive: NotificationBlock? {
            get { return getAction(for: UIApplication.didBecomeActiveNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.didBecomeActiveNotification) }
        }

        public var willResignActive: NotificationBlock? {
            get { return getAction(for: UIApplication.willResignActiveNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.willResignActiveNotification) }
        }

        public var didReceiveMemoryWarning: NotificationBlock? {
            get { return getAction(for: UIApplication.didReceiveMemoryWarningNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.didReceiveMemoryWarningNotification) }
        }

        public var willTerminate: NotificationBlock? {
            get { return getAction(for: UIApplication.willTerminateNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.willTerminateNotification) }
        }

        public var significantTimeChange: NotificationBlock? {
            get { return getAction(for: UIApplication.significantTimeChangeNotification) }
            set { setAction(using: newValue, object: nil, name: UIApplication.significantTimeChangeNotification) }
        }
    }
#endif
