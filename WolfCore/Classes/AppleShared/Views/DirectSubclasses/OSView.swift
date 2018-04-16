//
//  OSView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(Cocoa)
    import Cocoa
    public typealias OSView = NSView
    public typealias OSStackView = NSStackView
    public typealias OSImageView = NSImageView
    public typealias OSEdgeInsets = NSEdgeInsets
    public let OSEdgeInsetsZero = NSEdgeInsetsZero
    public let OSViewNoIntrinsicMetric = NSView.noIntrinsicMetric

    extension OSStackView {
        public var axis: NSUserInterfaceLayoutOrientation {
            get { return orientation }
            set { orientation = newValue }
        }
    }
#elseif canImport(UIKit)
    import UIKit
    public typealias OSView = UIView
    public typealias OSStackView = UIStackView
    public typealias OSImageView = UIImageView
    public typealias OSEdgeInsets = UIEdgeInsets
    public let OSEdgeInsetsZero = UIEdgeInsets.zero
    public let OSViewNoIntrinsicMetric = UIViewNoIntrinsicMetric
#endif

public typealias ViewBlock = (OSView) -> Bool
