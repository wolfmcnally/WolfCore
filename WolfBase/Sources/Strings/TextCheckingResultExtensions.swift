//
//  TextCheckingResultExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/5/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

extension TextCheckingResult {
  public func range(atIndex index: Int, inString string: String) -> Range<String.Index> {
    return string.stringRange(from: range(at: index))!
  }

  public func captureRanges(inString string: String) -> [Range<String.Index>] {
    var result = [Range<String.Index>]()
    for i in 1 ..< numberOfRanges {
      result.append(range(atIndex: i, inString: string))
    }
    return result
  }
}

extension TextCheckingResult {
  public func get(atIndex index: Int, inString string: String) -> (Range<String.Index>, String) {
    let range = self.range(atIndex: index, inString: string)
    let text = String(string[range])
    return (range, text)
  }
}
