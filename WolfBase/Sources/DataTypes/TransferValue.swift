//
//  TransferValue.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

public class TransferValue<T: Any>: Reference {
  public let defaultValue: T
  
  public typealias Source = () -> T?
  public typealias Sink = (T) -> Void
  
  public init(withDefault defaultValue: T, sink: Sink?) {
    self.defaultValue = defaultValue
    if let sink = sink {
      self.sink = sink
    }
  }
  
  public var source: Source? {
    didSet {
      transfer()
    }
  }
  
  public var sink: Sink? {
    didSet {
      transfer()
    }
  }
  
  public var hasReferent: Bool { return true }
  
  public var referent: T {
    return source?() ?? defaultValue
  }
  
  public func transfer() {
    sink?(referent)
  }
}
