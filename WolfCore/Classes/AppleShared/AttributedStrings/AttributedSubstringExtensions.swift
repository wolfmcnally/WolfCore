//
//  AttributedSubstringExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

extension NSAttributedStringKey {
    public static let overrideTintColorTag = NSAttributedStringKey("overrideTintColorTag")
}

#if os(watchOS)
    extension NSAttributedStringKey {
        public static let font = NSAttributedStringKey("NSFont")
        public static let foregroundColor = NSAttributedStringKey("NSColor")
        public static let paragraphStyle = NSAttributedStringKey("NSParagraphStyle")
    }
#endif

extension AttributedSubstring {
    public var font: OSFont {
        get {
            return attribute(.font) as? OSFont ?? OSFont.systemFont(ofSize: 12)
        }
        set { addAttribute(.font, value: newValue) }
    }

    public var foregroundColor: OSColor {
        get { return attribute(.foregroundColor) as? OSColor ?? .black }
        set { addAttribute(.foregroundColor, value: newValue) }
    }

    public var paragraphStyle: NSMutableParagraphStyle {
        get {
            if let value = attribute(.paragraphStyle) as? NSParagraphStyle {
                return value.mutableCopy() as! NSMutableParagraphStyle
            } else {
                return NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            }
        }
        set { addAttribute(.paragraphStyle, value: newValue) }
    }

    public var textAlignment: NSTextAlignment {
        get {
            return self.paragraphStyle.alignment
        }
        set {
            let paragraphStyle = self.paragraphStyle
            paragraphStyle.alignment = newValue
            self.paragraphStyle = paragraphStyle
        }
    }

    public var overrideTintColor: Bool {
        get { return hasTag(.overrideTintColorTag) }
        set {
            if newValue {
                addTag(.overrideTintColorTag)
            } else {
                removeAttribute(.overrideTintColorTag)
            }
        }
    }
}
