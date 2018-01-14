//
//  OSGestureRecognizer.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias OSGestureRecognizer = NSGestureRecognizer
    public typealias OSGestureRecognizerDelegate = NSGestureRecognizerDelegate
    public typealias OSGestureRecognizerState = NSGestureRecognizer.State
    public typealias OSTapClickGestureRecognizer = NSClickGestureRecognizer
    public typealias OSPanGestureRecognizer = NSPanGestureRecognizer
#else
    import UIKit
    public typealias OSGestureRecognizer = UIGestureRecognizer
    public typealias OSGestureRecognizerDelegate = UIGestureRecognizerDelegate
    public typealias OSGestureRecognizerState = UIGestureRecognizerState
    public typealias OSTapClickGestureRecognizer = UITapGestureRecognizer
    public typealias OSPanGestureRecognizer = UIPanGestureRecognizer
#endif