//
//  JSONUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

extension JSON {
  /// Get an `OSColor` value for a given key in the JSON dictionary. The value is nullable,
  /// and the return value will be `nil` if either the key does not exist or the value is `null`.
  /// An error will be thrown if the value exists but cannot be parsed into a color.
  public func getValue(for key: String) throws -> OSColor? {
    let c: Color? = try getValue(for: key)
    guard let d = c else { return nil }
    return OSColor(d)
  }

  /// Get an `OSColor` value for a given key in the JSON dictionary. The color will be parsed from a string value in
  /// the dictionary. If the `fallback` argument is provided, it will be substituted only if the key is `null`
  /// or nonexistent. An error will be thrown if the value exists but cannot be parsed into a `OSColor`.
  public func getValue(for key: String, fallback: OSColor? = nil) throws -> OSColor {
    var myFallback: Color?
    if let fallback = fallback {
      myFallback = Color(fallback)
    }
    let c: Color = try getValue(for: key, with: myFallback)
    return c.osColor
  }
}
