//
//  ArrayExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

extension Array {
  public func circularIndex(at index: Int) -> Int {
    return WolfBase.circularIndex(at: index, count: count)
  }
  
  public func element(atCircularIndex index: Int) -> Element {
    return self[circularIndex(at: index)]
  }
  
  public mutating func replaceElement(atCircularIndex index: Index, withElement element: Element) {
    self[circularIndex(at: index)] = element
  }
  
  public var randomIndex: Int {
    return Random.number(0 ..< self.count)
  }
  
  public var randomElement: Element {
    return self[randomIndex]
  }
  
  /// Fisher–Yates shuffle
  /// http://datagenetics.com/blog/november42014/index.html
  public var shuffled: Array<Element> {
    var result = self
    let hi = count - 1
    for a in 0 ..< hi {
      let b = Random.number(a + 1 ..< count)
      result.swapAt(a, b)
    }
    return result
  }
}

extension Sequence {
  public func flatJoined(separator: String = "") -> String {
    let a = flatMap { (i) -> String? in
      if let o = i as? OptionalProtocol {
        if o.isSome() {
          return o.unwrappedString()
        } else {
          return nil
        }
      }
      return String(describing: i)
    }
    return a.joined(separator: separator)
  }
}

extension Array {
  public func split(by size: Int) -> [[Element]] {
    return stride(from: 0, to: self.count, by: size).map { start in
      let end = self.index(start, offsetBy: size, limitedBy: self.count) ?? self.endIndex
      return Array(self[start ..< end])
    }
  }
}

public func circularIndex(at index: Int, count: Int) -> Int {
  guard count > 0 else {
    return 0
  }
  
  let i = index % count
  return i >= 0 ? i : i + count
}
