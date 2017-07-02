//
//  JSONRepresentable.swift
//  WolfBase
//
//  Created by Wolf McNally on 4/1/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol JSONRepresentable {
  var json: JSON { get }
}

extension Int: JSONRepresentable {
  public var json: JSON { return JSON(self) }
}

extension Double: JSONRepresentable {
  public var json: JSON { return JSON(self) }
}

extension Float: JSONRepresentable {
  public var json: JSON { return JSON(self) }
}

extension Bool: JSONRepresentable {
  public var json: JSON { return JSON(self) }
}

extension String: JSONRepresentable {
  public var json: JSON { return JSON(self) }
}

extension JSON: JSONRepresentable {
  public var json: JSON { return self }
}

extension URL: JSONRepresentable {
  public var json: JSON { return JSON(absoluteString) }
}

extension Date: JSONRepresentable {
  public var json: JSON { return JSON(iso8601) }
}

extension NSNumber: JSONRepresentable {
  public var json: JSON { return JSON(doubleValue) }
}

extension Locale: JSONRepresentable {
  public var json: JSON { return JSON(String(describing: self)) }
}

extension NSNull: JSONRepresentable {
  public var json: JSON { return JSON(JSON.null) }
}
