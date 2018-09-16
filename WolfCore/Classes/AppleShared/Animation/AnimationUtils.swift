//
//  AnimationUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/20/15.
//  Copyright © 2015 WolfMcNally.com.
//

#if canImport(AppKit)
    import AppKit
    public struct OSViewAnimationOptions: OptionSet {
        public let rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static var layoutSubviews            = OSViewAnimationOptions(rawValue: 1 <<  0)
        public static var allowUserInteraction      = OSViewAnimationOptions(rawValue: 1 <<  1)
        public static var beginFromCurrentState     = OSViewAnimationOptions(rawValue: 1 <<  2)
        public static var `repeat`                  = OSViewAnimationOptions(rawValue: 1 <<  3)
        public static var autoreverse               = OSViewAnimationOptions(rawValue: 1 <<  4)
        public static var overrideInheritedDuration = OSViewAnimationOptions(rawValue: 1 <<  5)
        public static var overrideInheritedCurve    = OSViewAnimationOptions(rawValue: 1 <<  6)
        public static var allowAnimatedContent      = OSViewAnimationOptions(rawValue: 1 <<  7)
        public static var showHideTransitionViews   = OSViewAnimationOptions(rawValue: 1 <<  8)
        public static var overrideInheritedOptions  = OSViewAnimationOptions(rawValue: 1 <<  9)

        public static var curveEaseInOut            = OSViewAnimationOptions(rawValue: 0 << 16)
        public static var curveEaseIn               = OSViewAnimationOptions(rawValue: 1 << 16)
        public static var curveEaseOut              = OSViewAnimationOptions(rawValue: 2 << 16)
        public static var curveLinear               = OSViewAnimationOptions(rawValue: 3 << 16)

        public static var transitionFlipFromLeft    = OSViewAnimationOptions(rawValue: 1 << 20)
        public static var transitionFlipFromRight   = OSViewAnimationOptions(rawValue: 2 << 20)
        public static var transitionCurlUp          = OSViewAnimationOptions(rawValue: 3 << 20)
        public static var transitionCurlDown        = OSViewAnimationOptions(rawValue: 4 << 20)
        public static var transitionCrossDissolve   = OSViewAnimationOptions(rawValue: 5 << 20)
        public static var transitionFlipFromTop     = OSViewAnimationOptions(rawValue: 6 << 20)
        public static var transitionFlipFromBottom  = OSViewAnimationOptions(rawValue: 7 << 20)
    }
#elseif canImport(UIKit)
    import UIKit
    public typealias OSViewAnimationOptions = UIView.AnimationOptions
#endif

public let defaultAnimationDuration: TimeInterval = 0.4

#if os(macOS)

    public func dispatchAnimated(_ animated: Bool = true, duration: TimeInterval = defaultAnimationDuration, delay: TimeInterval = 0.0, options: OSViewAnimationOptions = [], animations: @escaping Block) -> SuccessPromise {
        return SuccessPromise { promise in
            if animated {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = duration
                    context.allowsImplicitAnimation = true
                    if options.contains(.curveEaseInOut) {
                        context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    } else if options.contains(.curveEaseIn) {
                        context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                    } else if options.contains(.curveEaseOut) {
                        context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                    } else if options.contains(.curveLinear) {
                        context.timingFunction = CAMediaTimingFunction(name: .linear)
                    }
                    animations()
                }, completionHandler: {
                    promise.keep(())
                }
                )
            } else {
                animations()
                promise.keep(())
            }
        }
    }

#else

    public func dispatchAnimated(_ animated: Bool = true, duration: TimeInterval = defaultAnimationDuration, delay: TimeInterval = 0.0, options: OSViewAnimationOptions = [], animations: @escaping Block) -> Promise<Bool> {
        return Promise<Bool> { promise in
            checkMainThread()
            if animated {
                UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations) { finished in
                    promise.keep(finished)
                }
            } else {
                animations()
                promise.keep(true)
            }
        }
    }

public func animationOptions(for curve: UIView.AnimationCurve) -> UIView.AnimationOptions {
        switch curve {
        case .easeInOut:
            return [.curveEaseInOut]
        case .easeIn:
            return [.curveEaseIn]
        case .easeOut:
            return [.curveEaseOut]
        case .linear:
            return [.curveLinear]
        }
    }

#endif
