//
//  StringIndexesAndRanges.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

// KLUDGE: These are causing compiler crashes under Swift 3.1.
//
//public typealias StringIndex = String.Index
//public typealias StringRange = Range<StringIndex>
//public typealias RangeReplacement = (Range<String.Index>, String)

extension String {
    public func stringRange(from nsRange: NSRange?) -> Range<String.Index>? {
        guard let nsRange = nsRange else { return nil }
        let utf16view = utf16
        let from16 = utf16view.index(utf16view.startIndex, offsetBy: nsRange.location, limitedBy: utf16view.endIndex)!
        let to16 = utf16view.index(from16, offsetBy: nsRange.length, limitedBy: utf16view.endIndex)!
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    public func location(fromIndex index: String.Index) -> Int {
        return nsRange(from: index..<index)!.location
    }
    
    public func index(fromLocation location: Int) -> String.Index {
        return stringRange(from: NSRange(location: location, length: 0))!.lowerBound
    }
    
    public func nsRange(from stringRange: Range<String.Index>?) -> NSRange? {
        guard let stringRange = stringRange else { return nil }
        let utf16view = utf16
        let from = String.UTF16View.Index(stringRange.lowerBound, within: utf16view)!
        let to = String.UTF16View.Index(stringRange.upperBound, within: utf16view)!
        let location = utf16view.distance(from: utf16view.startIndex, to: from)
        let length = utf16view.distance(from: from, to: to)
        return NSRange(location: location, length: length)
    }
    
    public var nsRange: NSRange {
        return nsRange(from: stringRange)!
    }
    
    public var stringRange: Range<String.Index> {
        return startIndex..<endIndex
    }
    
    public func stringRange(start: Int, end: Int? = nil) -> Range<String.Index> {
        let s = self.index(self.startIndex, offsetBy: start)
        let e = self.index(self.startIndex, offsetBy: (end ?? start))
        return s..<e
    }
    
    public func stringRange(r: Range<Int>) -> Range<String.Index> {
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
    public func convert(index: String.Index, fromString string: String, offset: Int = 0) -> String.Index {
        let distance = string.distance(from: string.startIndex, to: index) + offset
        return self.index(self.startIndex, offsetBy: distance)
    }
    
    public func convert(index: String.Index, toString string: String, offset: Int = 0) -> String.Index {
        let distance = self.distance(from: self.startIndex, to: index) + offset
        return string.index(string.startIndex, offsetBy: distance)
    }
    
    public func convert(range: Range<String.Index>, fromString string: String, offset: Int = 0) -> Range<String.Index> {
        let s = convert(index: range.lowerBound, fromString: string, offset: offset)
        let e = convert(index: range.upperBound, fromString: string, offset: offset)
        return s..<e
    }
    
    public func convert(range: Range<String.Index>, toString string: String, offset: Int = 0) -> Range<String.Index> {
        let s = convert(index: range.lowerBound, toString: string, offset: offset)
        let e = convert(index: range.upperBound, toString: string, offset: offset)
        return s..<e
    }
}

