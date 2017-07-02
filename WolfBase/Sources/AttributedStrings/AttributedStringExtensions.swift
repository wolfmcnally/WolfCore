//
//  AttributedStringExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

extension AttributedString {
  public var count: Int {
    return string.characters.count
  }

  public func attributedSubstring(from range: Range<String.Index>) -> AttributedString {
    return attributedSubstring(from: string.nsRange(from: range)!)§
  }

  public func attributes(at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> StringAttributes {
    let location = string.location(fromIndex: index)
    let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
    let attrs = attributes(at: location, longestEffectiveRange: nil, in: nsRangeLimit)
    return attrs
  }

  public func attributesWithLongestEffectiveRange(at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> (attributes: StringAttributes, longestEffectiveRange: Range<String.Index>) {
    let location = string.location(fromIndex: index)
    let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
    var nsRange = NSRange()
    let attrs = attributes(at: location, longestEffectiveRange: &nsRange, in: nsRangeLimit)
    let range = string.stringRange(from: nsRange)!
    return (attrs, range)
  }

  public func attribute(_ name: NSAttributedStringKey, at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> Any? {
    let location = string.location(fromIndex: index)
    let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
    let attr = attribute(name, at: location, longestEffectiveRange: nil, in: nsRangeLimit)
    return attr
  }

  public func attributeWithLongestEffectiveRange(_ name: NSAttributedStringKey, at index: String.Index, in rangeLimit: Range<String.Index>? = nil) -> (attribute: Any?, longestEffectiveRange: Range<String.Index>) {
    let location = string.location(fromIndex: index)
    let nsRangeLimit = string.nsRange(from: rangeLimit) ?? string.nsRange
    var nsRange = NSRange()
    let attr = attribute(name, at: location, longestEffectiveRange: &nsRange, in: nsRangeLimit)
    let range = string.stringRange(from: nsRange)!
    return (attr, range)
  }

  // swiftlint:disable:next custom_rules
  public func enumerateAttributes(in enumerationRange: Range<String.Index>? = nil, options opts: NSAttributedString.EnumerationOptions = [], using block: (StringAttributes, Range<String.Index>, AttributedSubstring) -> Bool) {
    let nsRange = string.nsRange(from: enumerationRange) ?? string.nsRange
    enumerateAttributes(in: nsRange, options: opts) { (attrs, nsRange, stop) in
      let range = self.string.stringRange(from: nsRange)!
      stop[0] = ObjCBool(block(attrs, range, self.substring(in: range)))
    }
  }

  // swiftlint:disable:next custom_rules
  public func enumerateAttribute(_ name: NSAttributedStringKey, in enumerationRange: Range<String.Index>? = nil, options opts: NSAttributedString.EnumerationOptions = [], using block: (Any?, Range<String.Index>, AttributedSubstring) -> Bool) {
    let nsEnumerationRange = string.nsRange(from: enumerationRange) ?? string.nsRange
    enumerateAttribute(name, in: nsEnumerationRange, options: opts) { (value, nsRange, stop) in
      let range = self.string.stringRange(from: nsRange)!
      stop[0] = ObjCBool(block(value, range, self.substring(in: range)))
    }
  }

  public func replaceCharacters(in range: Range<String.Index>, with str: String) {
    let nsRange = string.nsRange(from: range)!
    replaceCharacters(in: nsRange, with: str)
  }

  public func setAttributes(_ attrs: StringAttributes?, range: Range<String.Index>? = nil) {
    let nsRange = string.nsRange(from: range) ?? string.nsRange
    setAttributes(attrs, range: nsRange)
  }

  public func addAttribute(_ name: NSAttributedStringKey, value: Any, range: Range<String.Index>? = nil) {
    let nsRange = string.nsRange(from: range) ?? string.nsRange
    addAttribute(name, value: value, range: nsRange)
  }

  public func addAttributes(_ attrs: StringAttributes, range: Range<String.Index>? = nil) {
    let nsRange = string.nsRange(from: range) ?? string.nsRange
    addAttributes(attrs, range: nsRange)
  }

  public func removeAttribute(_ name: NSAttributedStringKey, range: Range<String.Index>? = nil) {
    let nsRange = string.nsRange(from: range) ?? string.nsRange
    removeAttribute(name, range: nsRange)
  }

  public func replaceCharacters(in range: Range<String.Index>, with attrString: AttributedString) {
    let nsRange = string.nsRange(from: range)!
    replaceCharacters(in: nsRange, with: attrString)
  }

  public func insert(_ attrString: AttributedString, at index: String.Index) {
    let location = string.location(fromIndex: index)
    insert(attrString, at: location)
  }

  public func deleteCharacters(in range: Range<String.Index>) {
    let nsRange = string.nsRange(from: range)!
    deleteCharacters(in: nsRange)
  }
}

extension AttributedString {
  public func substring(in range: Range<String.Index>? = nil) -> AttributedSubstring {
    return AttributedSubstring(string: self, range: range)
  }

  public func substring(from index: String.Index) -> AttributedSubstring {
    return AttributedSubstring(string: self, fromIndex: index)
  }

  public func substrings(withTag tag: NSAttributedStringKey) -> [AttributedSubstring] {
    var result = [AttributedSubstring]()

    var index = string.startIndex
    while index < string.endIndex {
      let (attrs, longestEffectiveRange) = attributesWithLongestEffectiveRange(at: index)
      if attrs[tag] as? Bool == true {
        let substring = AttributedSubstring(string: self, range: longestEffectiveRange)
        result.append(substring)
        index = longestEffectiveRange.upperBound
      }
      index = string.index(index, offsetBy: 1)
    }

    return result
  }
}

extension AttributedString {
  public var tag: NSAttributedStringKey {
    get { return substring().tag }
    set { substring().tag = newValue }
  }

  public subscript(attribute: NSAttributedStringKey) -> Any? {
    get { return substring()[attribute] }
    set { substring()[attribute] = newValue! }
  }

  public func getString(forTag tag: NSAttributedStringKey, atIndex index: String.Index) -> String? {
    return substring(from: index).getString(forTag: tag)
  }

  public func has(tag: NSAttributedStringKey, atIndex index: String.Index) -> Bool {
    return substring(from: index).hasTag(tag)
  }

  public func edit(f: (AttributedSubstring) -> Void) {
    beginEditing()
    f(substring())
    endEditing()
  }

  public func edit(in range: Range<String.Index>, f: (AttributedSubstring) -> Void) {
    beginEditing()
    f(substring(in: range))
    endEditing()
  }
}

extension AttributedString {
  public func printAttributes() {
    let aliaser = ObjectAliaser()
    var strIndex = string.startIndex
    for char in string.characters {
      let joiner = Joiner()
      joiner.append(char)
      let attrs: StringAttributes = attributes(at: strIndex)
      for(name, value) in attrs {
        let v = value as AnyObject
        joiner.append("\(name):\(aliaser.name(for: v))")
      }
      print(joiner)
      strIndex = string.index(strIndex, offsetBy: 1)
    }
  }
}

