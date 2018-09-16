//
//  ArrayExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/5/15.
//  Copyright © 2015 WolfMcNally.com.
//

import WolfNumerics

extension RangeReplaceableCollection {
    @discardableResult public mutating func arrange(from: Index, to: Index) -> Bool {
        precondition(indices.contains(from) && indices.contains(to), "invalid indexes")
        guard from != to else { return false }
        insert(remove(at: from), at: to)
        return true
    }
}

extension Collection {
    public var randomIndex: Index {
        return index(startIndex, offsetBy: Random.number(0 ..< count))
    }

    public var randomElement: Element {
        return self[randomIndex]
    }

    public func circularIndex(at index: Int) -> Index {
        return self.index(startIndex, offsetBy: makeCircularIndex(at: index, count: count))
    }

    public func element(atCircularIndex index: Int) -> Element {
        return self[circularIndex(at: index)]
    }
}

extension MutableCollection {
    public mutating func replaceElement(atCircularIndex index: Int, withElement element: Element) {
        self[circularIndex(at: index)] = element
    }
}

//extension Array {
//
//    /// Fisher–Yates shuffle
//    /// http://datagenetics.com/blog/november42014/index.html
//    public var shuffled: [Element] {
//        var result = self
//        let hi = count - 1
//        for a in 0 ..< hi {
//            let b = Random.number(a + 1 ..< count)
//            result.swapAt(a, b)
//        }
//        return result
//    }
//
//    public func appending(_ newElement: Element) -> Array {
//        var s = self
//        s.append(newElement)
//        return s
//    }
//}

extension Sequence {
    public func flatJoined(separator: String = "") -> String {
        let a = compactMap { (i) -> String? in
            if let o = i as? OptionalProtocol {
                if o.isSome {
                    return o.unwrappedString()
                } else {
                    return nil
                }
            }
            return String(describing: i)
        }
        return a.joined(separator: separator)
    }

    public func filtermap<T>(_ transform: (Element) -> T?) -> [T] {
        var result = [T]()
        forEach {
            guard let t = transform($0) else { return }
            result.append(t)
        }
        return result
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

public func makeCircularIndex(at index: Int, count: Int) -> Int {
    guard count > 0 else {
        return 0
    }

    let i = index % count
    return i >= 0 ? i : i + count
}
