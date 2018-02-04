//
//  OSFont.swift
//  WolfCoreOS
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias OSFont = NSFont
    public typealias OSFontDescriptor = NSFontDescriptor
    extension NSFont {
        public static var familyNames: [String] {
            return NSFontManager.shared.availableFontFamilies
        }
        public static func fontNames(forFamilyName family: String) -> [String] {
            guard let members = NSFontManager.shared.availableMembers(ofFontFamily: family) else { return [] }
            return members.map { $0[0] as! String }
        }
    }
#else
    import UIKit
    public typealias OSFont = UIFont
    public typealias OSFontDescriptor = UIFontDescriptor
#endif
