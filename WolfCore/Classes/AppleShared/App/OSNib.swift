//
//  OSNib.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(Cocoa)
    import Cocoa
    public typealias OSNib = NSNib
#elseif canImport(UIKit)
    import UIKit
    public typealias OSNib = UINib
#endif
