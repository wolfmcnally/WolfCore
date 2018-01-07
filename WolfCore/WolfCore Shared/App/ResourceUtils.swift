//
//  ResourceUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public func loadStoryboard(named name: String, in bundle: Bundle? = nil) -> OSStoryboard {
    let bundle = bundle ?? Bundle.main
    #if os(macOS)
        return NSStoryboard(name: NSStoryboard.Name(rawValue: name), bundle: bundle)
    #else
        return UIStoryboard(name: name, bundle: bundle)
    #endif
}

public func loadNib(named name: String, in bundle: Bundle? = nil) -> OSNib {
    let bundle = bundle ?? Bundle.main
    #if os(macOS)
        return NSNib(nibNamed: NSNib.Name(rawValue: name), bundle: bundle)!
    #else
        return UINib(nibName: name, bundle: bundle)
    #endif
}

public func loadView<T: OSView>(fromNibNamed name: String, in bundle: Bundle? = nil, owner: AnyObject? = nil) -> T {
    let nib = loadNib(named: name, in: bundle)
    #if os(macOS)
        var objs: NSArray? = nil
        nib.instantiate(withOwner: owner, topLevelObjects: &objs)
        return objs![0] as! T
    #else
        return nib.instantiate(withOwner: owner, options: nil)[0] as! T
    #endif
}
