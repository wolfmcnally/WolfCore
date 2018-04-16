//
//  ResourceUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

#if canImport(Cocoa)
    import Cocoa
#elseif canImport(UIKit)
    import UIKit
#endif

public func loadData(named name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil, in bundle: Bundle? = nil) throws -> Data {
    let bundle = bundle ?? Bundle.main
    return try bundle |> Bundle.urlForResource(name, withExtension: anExtension, subdirectory: subpath) |> URL.retrieveData
}

public struct ResourceReference: ExtensibleEnumeratedName, Reference {
    public let rawValue: String
    public let type: String?
    public let bundle: Bundle

    public init(_ rawValue: String, ofType type: String? = nil, in bundle: Bundle? = nil) {
        self.rawValue = rawValue
        self.type = type
        self.bundle = bundle ?? Bundle.main
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }

    // Reference
    public var referent: URL {
        return URL(fileURLWithPath: bundle.path(forResource: rawValue, ofType: type)!)
    }
}

public postfix func ® (lhs: ResourceReference) -> URL {
    return lhs.referent
}

#if !os(Linux)

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

#endif
