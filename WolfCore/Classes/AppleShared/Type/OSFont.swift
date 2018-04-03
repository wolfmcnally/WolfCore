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
public typealias OSFontDescriptorSymbolicTraits = NSFontDescriptor.SymbolicTraits
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
public typealias OSFontDescriptorSymbolicTraits = UIFontDescriptorSymbolicTraits
#endif

extension OSFontDescriptorSymbolicTraits {
    public mutating func insertBold() {
        #if os(macOS)
        insert(.bold)
        #else
        insert(.traitBold)
        #endif
    }

    public mutating func insertItalic() {
        #if os(macOS)
        insert(.italic)
        #else
        insert(.traitItalic)
        #endif
    }
}

extension OSFontDescriptor {
    public func makeWithSymbolicTraits(_ traits: OSFontDescriptorSymbolicTraits) -> OSFontDescriptor {
        #if os(macOS)
        return withSymbolicTraits(traits)
        #else
        return withSymbolicTraits(traits)!
        #endif
    }
}

extension OSFont {
    public static func makeWithDescriptor(_ descriptor: OSFontDescriptor, size: CGFloat = 0) -> OSFont {
        #if os(macOS)
        return NSFont(descriptor: descriptor, size: size)!
        #else
        return UIFont(descriptor: descriptor, size: size)
        #endif
    }
}
