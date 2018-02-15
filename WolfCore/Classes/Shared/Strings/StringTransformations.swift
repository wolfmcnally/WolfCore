//
//  StringTransformations.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

private let newlinesRegex = try! ~/"\n"

extension String {
    public func escapingNewlines() -> String {
        return replacing(matchesTo: newlinesRegex) { _ in
            return "\\n"
            }.string
    }

    public func truncated(afterCount count: Int, adding signifier: String? = "…") -> String {
        guard self.count > count else { return self }
        let s = self[startIndex..<index(startIndex, offsetBy: count)]
        return [s, signifier as Any].flatJoined()
    }
}

extension String {
    public func padded(to count: Int, onRight: Bool = false, with character: Character = " ") -> String {
        let startCount = self.count
        let padCount = count - startCount
        guard padCount > 0 else { return self }
        let pad = String(repeating: String(character), count: padCount)
        return onRight ? (self + pad) : (pad + self)
    }

    public static func padded(to count: Int, onRight: Bool = false, with character: Character = " ") -> (String) -> String {
        return { $0.padded(to: count, onRight: onRight, with: character) }
    }

    public func paddedWithZeros(to count: Int) -> String {
        return padded(to: count, onRight: false, with: "0")
    }

    public static func paddedWithZeros(to count: Int) -> (String) -> String {
        return { $0.paddedWithZeros(to: count) }
    }
}

extension String {
    public func nilIfEmpty() -> String? {
        return isEmpty ? nil : self
    }

    public static func emptyIfNil(_ string: String?) -> String {
        return string ?? ""
    }
}

extension String {
    public func split(by size: Int) -> [String] {
        var parts = [String]()
        var start = startIndex
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            parts.append(String(self[start ..< end]))
            start = end
        }
        return parts
    }

    public func capitalizedFirstCharacter() -> String {
        let first = String(self.first!).capitalized
        let rest = self.dropFirst()
        return first + rest
    }

    public func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func indented(_ level: Int = 1, with indentationMark: String = .tab, lineSeparator: String = .newline) -> String {
        let indentation = String(repeating: indentationMark, count: level)
        let newlineIndentation = lineSeparator + indentation
        let lines = components(separatedBy: lineSeparator)
        let indentedLines = lines.joined(separator: newlineIndentation)
        return indentation + indentedLines
    }
}
