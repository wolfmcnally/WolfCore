//
//  OSNib.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
  public typealias OSNib = NSNib
#else
  import UIKit
  public typealias OSNib = UINib
#endif
