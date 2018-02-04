//
//  DateExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/12/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

extension Calendar {
    /// Returns the last day of the month containing `date`. So if the date is in a January, this method will return January 31.
    public func lastDayOfMonth(for date: Date) -> Date {
        let dayRange = range(of: .day, in: .month, for: date)!
        let dayCount = dayRange.count
        var comp = dateComponents([.year, .month, .day], from: date)
        comp.day = dayCount
        return self.date(from: comp)!
    }

    /// Returns the year of `date`.
    public func year(of date: Date) -> Int {
        return dateComponents([.year], from: date).year!
    }

    /// Returns the day of the week of `date`. So if `date` falls on a Monday, this method will return 2.
    public func weekday(of date: Date) -> Int {
        return dateComponents([.weekday], from: date).weekday!
    }

    /// Returns the ordinality of the day of `date`, taking into account `self`'s firstWeekday setting.
    public func dayInWeek(of date: Date) -> Int {
        return ordinality(of: .weekday, in: .weekOfYear, for: date)!
    }

    /// Returns the date of the first day of the week containing `date`. So if `date` falls on a Tuesday and the user has set the calendar week to start on Sunday, the date returned will be at the start of that Sunday, two days back. If `date` falls on that same Tuesday and the user has set the calendar week to start on Monday, the date returned will be the start of that Monday, one day back.
    public func firstDayOfWeek(for date: Date) -> Date {
        var d = startOfDay(for: date)
        while weekday(of: d) != firstWeekday {
            d = self.date(byAdding: .day, value: -1, to: d)!
        }
        return d
    }

    /// Returns the date 24 hours after `date`.
    public func nextDay(after date: Date) -> Date {
        return self.date(byAdding: .day, value: 1, to: date)!
    }
}


// Provide for converting dates to and from ISO8601 format.
// Example: "1965-05-15T00:00:00.0Z"
extension Date {
    public static var iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
        return formatter
    }()

    public var iso8601: String {
        return type(of: self).iso8601Formatter.string(from: self)
    }

    public static var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    public var shortFormat: String {
        return type(of: self).shortDateFormatter.string(from: self)
    }
}

extension Date {
    public init(iso8601: String) throws {
        if let date = type(of: self).iso8601Formatter.date(from: iso8601) {
            let timeInterval = date.timeIntervalSinceReferenceDate
            self.init(timeIntervalSinceReferenceDate: timeInterval)
        } else {
            throw ValidationError(message: "Invalid ISO8601 format", violation: "8601Format")
        }
    }

    public init(year: Int, month: Int, day: Int) throws {
        guard year > 0 else {
            throw ValidationError(message: "Invalid year", violation: "dateFormat")
        }
        guard 1...12 ~= month else {
            throw ValidationError(message: "Invalid month", violation: "dateFormat")
        }
        guard 1...31 ~= day else {
            throw ValidationError(message: "Invalid day", violation: "dateFormat")
        }
        let yearString = String(year)
        let monthString = String(month).paddedWithZeros(to: 2)
        let dayString = String(day).paddedWithZeros(to: 2)
        try self.init(iso8601: "\(yearString)-\(monthString)-\(dayString)T00:00:00.0Z")
    }
}

extension Date {
    public init(millisecondsSince1970 ms: Double) {
        self.init(timeIntervalSince1970: ms / 1000.0)
    }

    public var millisecondsSince1970: Double {
        return timeIntervalSince1970 * 1000.0
    }
}

extension Date {
    public var julianMoment: Double {
        let secondsPerDay =  86400.0  // 24 * 60 * 60
        let gregorian20010101 = 2451910.5 // Julian date of 00:00 UT on 1st Jan 2001 which is NSDate's reference date.
        return self.timeIntervalSinceReferenceDate / secondsPerDay + gregorian20010101
    }

    public var julianDay: Int {
        let julianDayNumber = Int(round(julianMoment))
        return julianDayNumber
    }
}

extension Date {
    public init?(naturalLanguage s: String) {
        let type: NSTextCheckingResult.CheckingType = .date
        let detector = try! NSDataDetector(types: type.rawValue)
        let length = (s as NSString).length
        let range = NSRange(location: 0, length: length)
        guard let match = detector.firstMatch(in: s, options: .reportCompletion, range: range) else {
            return nil
        }
        guard match.range == range else { return nil }
        guard match.resultType == type else { return nil }
        if let date = match.date {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
}
