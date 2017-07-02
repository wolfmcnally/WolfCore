//
//  OptionalExtensions.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/22/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

//  The purpose of the † (dagger) postfix operator (typed by pressing option-t) is to create a string representation of an optional value that is the unwrapped version of the value if it is not nil, and simply "nil" if it is.
//
//    var a: Int?
//
//    print(a)          // prints "nil", also has warning, "Expression implicitly coerced from 'Int?' to Any"
//    print("\(a)")     // prints "nil"
//    print(a†)         // prints "nil"
//
//    a = 5
//
//    print(a)          // prints "Optional(5)", also has warning, "Expression implicitly coerced from 'Int?' to Any"
//    print("\(a)")     // prints "Optional(5)"
//    print(a†)         // prints "5"

public protocol OptionalProtocol {
  func unwrappedString() -> String
  func isSome() -> Bool
  func unwrap() -> Any
}

extension Optional: OptionalProtocol {
  public func unwrappedString() -> String {
    switch self {
    case .some(let wrapped as OptionalProtocol): return wrapped.unwrappedString()
    case .some(let wrapped): return String(describing: wrapped)
    case .none: return String(describing: self)
    }
  }
  
  public func isSome() -> Bool {
    switch self {
    case .none: return false
    case .some: return true
    }
  }
  
  public func unwrap() -> Any {
    switch self {
    case .none: preconditionFailure("trying to unwrap nil")
    case .some(let unwrapped): return unwrapped
    }
  }
}

public func unwrap<T>(_ any: T) -> Any
{
  guard let optional = any as? OptionalProtocol, optional.isSome() else {
    return any
  }
  return optional.unwrap()
}

postfix operator †
public postfix func † <X> (x: X?) -> String {
  return x.unwrappedString()
}

public func typeName<X>(of x: X) -> String {
  return "\(type(of: x))"
}

public func identifier<X: AnyObject>(of x: X) -> String {
  return "0x" + String(ObjectIdentifier(x).hashValue, radix: 16)
}

postfix operator ††
public postfix func †† <X: AnyObject>(x: X) -> String {
  return "<\(typeName(of: x)): \(identifier(of: x))>"
}
public postfix func †† <X: AnyObject>(x: X?) -> String {
  return x == nil ? "nil" : (x!)††
}
