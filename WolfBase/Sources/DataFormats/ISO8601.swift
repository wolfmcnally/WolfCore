//
//  ISO8601.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

private var iso8601Formatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
  return formatter
}()

public struct ISO8601 {
  public static func string(from date: Date) -> String {
    return iso8601Formatter.string(from: date)
  }
  
  public static func date(from string: String) throws -> Date {
    if let date = iso8601Formatter.date(from: string) {
      let timeInterval = date.timeIntervalSinceReferenceDate
      return Date(timeIntervalSinceReferenceDate: timeInterval)
    } else {
      throw ValidationError(message: "Invalid ISO8601 string: \(string).", violation: "iso8601Format")
    }
  }
}
