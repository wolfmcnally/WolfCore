//
//  OSColor.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
  import AppKit
  public typealias OSColor = NSColor
#elseif canImport(UIKit)
  import UIKit
  public typealias OSColor = UIColor
#endif

#if !os(macOS)
    @available(iOS 11.0, *)
    extension UIColor {
        public struct Name: ExtensibleEnumeratedName {
            public let rawValue: String

            public init(_ rawValue: String) {
                self.rawValue = rawValue
            }

            // RawRepresentable
            public init?(rawValue: String) { self.init(rawValue) }
        }

        public convenience init?(named name: UIColor.Name) {
            self.init(named: name.rawValue)
        }
    }
#endif
