//
//  StringReplacement.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public typealias Replacements = [String: String]

extension String {
  public func replacing(replacements: [(Range<String.Index>, String)]) -> (string: String, ranges: [Range<String.Index>]) {
    let source = self
    var target = self
    var targetReplacedRanges = [Range<String.Index>]()
    let sortedReplacements = replacements.sorted { $0.0.lowerBound < $1.0.lowerBound }

    var totalOffset = 0
    for (sourceRange, replacement) in sortedReplacements {
      let replacementCount = replacement.count
      let rangeCount = source.distance(from: sourceRange.lowerBound, to: sourceRange.upperBound)
      let offset = replacementCount - rangeCount

      let newTargetStartIndex: String.Index
      let originalTarget = target
      do {
        let targetStartIndex = target.convert(index: sourceRange.lowerBound, fromString: source, offset: totalOffset)
        let targetEndIndex = target.index(targetStartIndex, offsetBy: rangeCount)
        let targetReplacementRange = targetStartIndex..<targetEndIndex
        target.replaceSubrange(targetReplacementRange, with: replacement)
        newTargetStartIndex = target.convert(index: targetStartIndex, fromString: originalTarget)
      }

      targetReplacedRanges = targetReplacedRanges.map { originalTargetReplacedRange in
        let targetReplacedRange = target.convert(range: originalTargetReplacedRange, fromString: originalTarget)
        guard targetReplacedRange.lowerBound >= newTargetStartIndex else {
          return targetReplacedRange
        }
        let adjustedStart = target.index(targetReplacedRange.lowerBound, offsetBy: offset)
        let adjustedEnd = target.index(adjustedStart, offsetBy: replacementCount)
        return adjustedStart..<adjustedEnd
      }
      let targetEndIndex = target.index(newTargetStartIndex, offsetBy: replacementCount)
      let targetReplacedRange = newTargetStartIndex..<targetEndIndex
      targetReplacedRanges.append(targetReplacedRange)
      totalOffset = totalOffset + offset
    }

    return (target, targetReplacedRanges)
  }
}

extension String {
  public func replacing(matchesTo regex: NSRegularExpression, usingBlock block: ((Range<String.Index>, String)) -> String) -> (string: String, ranges: [Range<String.Index>]) {
    let results = (regex ~?? self).map { match -> (Range<String.Index>, String) in
      let matchRange = match.range(atIndex: 0, inString: self)
      let substring = String(self[matchRange])
      let replacement = block((matchRange, substring))
      return (matchRange, replacement)
    }
    return replacing(replacements: results)
  }
}

// (?:(?<!\\)#\{(\w+)\})
// The quick #{color} fox #{action} over #{subject}.
private let placeholderReplacementRegex = try! ~/"(?:(?<!\\\\)#\\{(\\w+)\\})"

extension String {
  public func replacingPlaceholders(with replacements: Replacements) -> String {
    var replacementsArray = [(Range<String.Index>, String)]()
    let matches = placeholderReplacementRegex ~?? self
    for match in matches {
      let matchRange = stringRange(from: match.range)!
      let placeholderRange = stringRange(from: match.range(at: 1))!
      let replacementName = String(self[placeholderRange])
      if let replacement = replacements[replacementName] {
        replacementsArray.append((matchRange, replacement))
      } else {
        logError("Replacement in \"\(self)\" not found for placeholder \"\(replacementName)\".")
      }
    }

    return replacing(replacements: replacementsArray).string
  }
}
