//
//  Log.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/10/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import os

public enum LogLevel: Int, Comparable {
    case trace
    case info
    case warning
    case error

    private static let symbols = ["🔷", "✅", "⚠️", "🚫"]

    public var symbol: String {
        return type(of: self).symbols[rawValue]
    }

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func == (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public var logger: Log? = Log()

public struct LogGroup: ExtensibleEnumeratedName {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}

public class Log {
    public var level = LogLevel.info
    public var locationLevel = LogLevel.error
    public private(set) var groupLevels = [LogGroup : LogLevel]()

    public func print<T>(_ message: @autoclosure () -> T, level: LogLevel, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {

        // Don't print if the global level is below the level of this message.
        guard level >= self.level else { return }

        // Do print if there's no group associated with the message.
        if let group = group {
            // Do print if the level of the associated group is at or above the global level.
            guard let groupLevel = groupLevels[group], groupLevel >= self.level else { return }
        }

        let a = Joiner()
        a.append(level.symbol)

        var secondSymbol = false

        if let group = group {
            let b = Joiner(left: "[", separator: ", ", right: "]")
            b.append(group.rawValue)
            a.append(b)
            secondSymbol = true
        }

        if let obj = obj {
            a.append(obj)
            secondSymbol = true
        }

        if secondSymbol {
            a.append(String.tab, level.symbol)
        }
        a.append(message())

        Swift.print(a)

        if level >= self.locationLevel {
            let d = Joiner(separator: ", ")
            d.append(shortenFile(file), "line: \(line)", function)
            Swift.print(String.tab, d)
        }
    }

    public func isGroupActive(_ group: LogGroup) -> Bool {
        return groupLevels[group] != nil
    }

    public func setGroup(_ group: LogGroup, active: Bool = true, level: LogLevel = .trace) {
        if active {
            groupLevels[group] = level
        } else {
            groupLevels[group] = nil
        }
    }

    private func shortenFile(_ file: String) -> String {
        let components = file.components(separatedBy: "/")
        let originalCount = components.count
        let newCount = min(3, components.count)
        let end = originalCount
        let begin = end - newCount
        let lastComponents = components[begin..<end]
        let result = lastComponents.joined(separator: "/")
        return result
    }

    public func trace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .trace, obj: obj, group: group, file, line, function)
    }

    public func info<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .info, obj: obj, group: group, file, line, function)
    }

    public func warning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .warning, obj: obj, group: group, file, line, function)
    }

    public func error<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
        self.print(message, level: .error, obj: obj, group: group, file, line, function)
    }
}

public func logTrace<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.trace(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logInfo<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.info(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logWarning<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.warning(message, obj: obj, group: group, file, line, function)
    #endif
}

public func logError<T>(_ message: @autoclosure () -> T, obj: Any? = nil, group: LogGroup? = nil, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if !NO_LOG
        logger?.error(message, obj: obj, group: group, file, line, function)
    #endif
}
