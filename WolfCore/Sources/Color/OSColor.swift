//
//  OSColor.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
  public typealias OSColor = NSColor
#else
  import UIKit
  public typealias OSColor = UIColor
#endif
