//
//  AttributedSubstring.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public class AttributedSubstring {
    public let attrString: AttributedString
    public let strRange: Range<String.Index>
    public let nsRange: NSRange
    
    public init(string attrString: AttributedString, range strRange: Range<String.Index>? = nil) {
        self.attrString = attrString
        self.strRange = strRange ?? attrString.string.stringRange
        self.nsRange = attrString.string.nsRange(from: self.strRange)!
    }
    
    public convenience init(string attrString: AttributedString, fromIndex index: String.Index) {
        self.init(string: attrString, range: index..<attrString.string.endIndex)
    }
    
    public convenience init(string attrString: AttributedString) {
        self.init(string: attrString, range: attrString.string.startIndex..<attrString.string.endIndex)
    }
    
    public var count: Int {
        return attrString.string.distance(from: strRange.lowerBound, to: strRange.upperBound)
    }
    
    public var attributedSubstring: AttributedString {
        return attrString.attributedSubstring(from: strRange)
    }
    
    public func attributes(in rangeLimit: Range<String.Index>? = nil) -> StringAttributes {
        return attrString.attributes(at: strRange.lowerBound, in: rangeLimit)
    }
    
    public func attributesWithLongestEffectiveRange(in rangeLimit: Range<String.Index>? = nil) -> (attributes: StringAttributes, longestEffectiveRange: Range<String.Index>) {
        return attrString.attributesWithLongestEffectiveRange(at: strRange.lowerBound, in: rangeLimit)
    }
    
    public func attribute(_ name: NSAttributedStringKey, in rangeLimit: Range<String.Index>? = nil) -> Any? {
        return attrString.attribute(name, at: strRange.lowerBound, in: rangeLimit)
    }
    
    public func attributeWithLongestEffectiveRange(_ name: NSAttributedStringKey, in rangeLimit: Range<String.Index>? = nil) -> (attribute: Any?, longestEffectiveRange: Range<String.Index>) {
        return attrString.attributeWithLongestEffectiveRange(name, at: strRange.lowerBound, in: rangeLimit)
    }
    
    // swiftlint:disable:next custom_rules
    public func enumerateAttributes(options opts: NSAttributedString.EnumerationOptions = [], using block: (StringAttributes, Range<String.Index>, AttributedSubstring) -> Bool) {
        attrString.enumerateAttributes(in: strRange, options: opts, using: block)
    }
    
    // swiftlint:disable:next custom_rules
    public func enumerateAttribute(_ name: NSAttributedStringKey, options opts: NSAttributedString.EnumerationOptions = [], using block: (Any?, Range<String.Index>, AttributedSubstring) -> Bool) {
        attrString.enumerateAttribute(name, in: strRange, options: opts, using: block)
    }
    
    public func setAttributes(_ attrs: StringAttributes?) {
        attrString.setAttributes(attrs, range: strRange)
    }
    
    public func addAttribute(_ name: NSAttributedStringKey, value: Any) {
        attrString.addAttribute(name, value: value, range: strRange)
    }
    
    public func addAttributes(_ attrs: StringAttributes) {
        attrString.addAttributes(attrs, range: strRange)
    }
    
    public func removeAttribute(_ name: NSAttributedStringKey) {
        attrString.removeAttribute(name, range: strRange)
    }
}

extension AttributedSubstring : CustomStringConvertible {
    public var description: String {
        let s = attrString.string[strRange]
        return "(AttributedSubstring attrString:\(s), strRange:\(strRange))"
    }
}

extension AttributedSubstring {
    public func addTag(_ tag: NSAttributedStringKey) {
        self[tag] = true
    }
    
    public func getRange(forTag tag: NSAttributedStringKey) -> Range<String.Index>? {
        let (value, longestEffectiveRange) = attributeWithLongestEffectiveRange(tag)
        if value is Bool {
            return longestEffectiveRange
        } else {
            return nil
        }
    }
    
    public func getString(forTag tag: NSAttributedStringKey) -> String? {
        if let range = getRange(forTag: tag) {
            return String(attrString.string[range])
        } else {
            return nil
        }
    }
    
    public func hasTag(_ tag: NSAttributedStringKey) -> Bool {
        return getRange(forTag: tag) != nil
    }
    
    public subscript(name: NSAttributedStringKey) -> Any? {
        get {
            return attribute(name)
        }
        set {
            if let newValue = newValue {
                addAttribute(name, value: newValue)
            } else {
                removeAttribute(name)
            }
        }
    }
    
    public var tag: NSAttributedStringKey {
        get { fatalError("Unimplemented.") }
        set { addTag(newValue) }
    }
}
