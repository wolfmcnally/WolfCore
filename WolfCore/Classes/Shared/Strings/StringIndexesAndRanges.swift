//
//  StringIndexesAndRanges.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

// KLUDGE: These are causing compiler crashes under Swift 3.1.
//
public typealias StringIndex = String.Index
public typealias StringRange = Range<StringIndex>
public typealias RangeReplacement = (StringRange, String)

extension String {
    public func descriptionOfRange(_ range: StringRange) -> String {
        let rangeStart = distance(from: startIndex, to: range.lowerBound)
        let rangeEnd = distance(from: startIndex, to: range.upperBound)
        let rangeCount = distance(from: range.lowerBound, to: range.upperBound)
        return "[\(rangeStart) ..< \(rangeEnd)] (\(rangeCount))"
    }
    
    public func stringRange(nsLocation: Int, nsLength: Int) -> StringRange? {
        let utf16view = utf16
        let from16 = utf16view.index(utf16view.startIndex, offsetBy: nsLocation, limitedBy: utf16view.endIndex)!
        let to16 = utf16view.index(from16, offsetBy: nsLength, limitedBy: utf16view.endIndex)!
        if let from = StringIndex(from16, within: self),
            let to = StringIndex(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    public func stringRange(from nsRange: NSRange?) -> StringRange? {
        guard let nsRange = nsRange else { return nil }
        return stringRange(nsLocation: nsRange.location, nsLength: nsRange.length)
    }

    public func stringRange(from cfRange: CFRange?) -> StringRange? {
        guard let cfRange = cfRange else { return nil }
        return stringRange(nsLocation: cfRange.location, nsLength: cfRange.length)
    }
    
    public func nsLocation(fromIndex index: StringIndex) -> Int {
        return nsRange(from: index..<index)!.location
    }
    
    public func index(fromLocation nsLocation: Int) -> StringIndex {
        return stringRange(from: NSRange(location: nsLocation, length: 0))!.lowerBound
    }
    
    public func nsRange(from stringRange: StringRange?) -> NSRange? {
        guard let stringRange = stringRange else { return nil }
        let utf16view = utf16
        let from = String.UTF16View.Index(stringRange.lowerBound, within: utf16view)!
        let to = String.UTF16View.Index(stringRange.upperBound, within: utf16view)!
        let location = utf16view.distance(from: utf16view.startIndex, to: from)
        let length = utf16view.distance(from: from, to: to)
        return NSRange(location: location, length: length)
    }

    public func cfRange(from stringRange: StringRange?) -> CFRange? {
        guard let r = nsRange(from: stringRange) else { return nil }
        return CFRange(nsRange: r)
    }

    public var nsRange: NSRange {
        return nsRange(from: stringRange)!
    }

    public var cfRange: CFRange {
        return cfRange(from: stringRange)!
    }
    
    public var stringRange: StringRange {
        return startIndex..<endIndex
    }
    
    public func stringRange(start: Int, end: Int? = nil) -> StringRange {
        let s = self.index(self.startIndex, offsetBy: start)
        let e = self.index(self.startIndex, offsetBy: (end ?? start))
        return s..<e
    }

    public func stringRange(r: Range<Int>) -> StringRange {
        return stringRange(start: r.lowerBound, end: r.upperBound)
    }
    
    public func substring(start: Int, end: Int? = nil) -> String {
        return String(self[stringRange(start: start, end: end)])
    }
    
    public func substring(r: Range<Int>) -> String {
        return substring(start: r.lowerBound, end: r.upperBound)
    }
}

extension String {
    public func convert(index: StringIndex, fromString string: String, offset: Int = 0) -> StringIndex {
        let distance = string.distance(from: string.startIndex, to: index) + offset
        return self.index(self.startIndex, offsetBy: distance)
    }
    
    public func convert(index: StringIndex, toString string: String, offset: Int = 0) -> StringIndex {
        let distance = self.distance(from: self.startIndex, to: index) + offset
        return string.index(string.startIndex, offsetBy: distance)
    }
    
    public func convert(range: StringRange, fromString string: String, offset: Int = 0) -> StringRange {
        let s = convert(index: range.lowerBound, fromString: string, offset: offset)
        let e = convert(index: range.upperBound, fromString: string, offset: offset)
        return s..<e
    }
    
    public func convert(range: StringRange, toString string: String, offset: Int = 0) -> StringRange {
        let s = convert(index: range.lowerBound, toString: string, offset: offset)
        let e = convert(index: range.upperBound, toString: string, offset: offset)
        return s..<e
    }
}

