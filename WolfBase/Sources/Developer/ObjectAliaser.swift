//
//  ObjectAliaser.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/18/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import Foundation

/// Creates short, unique, descriptive names for a set of related objects.
public class ObjectAliaser {
  private var aliases = [ObjectIdentifier: Int]()
  private var nextAlias = 0

  public init() { }

  func alias(for object: AnyObject) -> Int {
    let objectIdentifier = ObjectIdentifier(object)
    var alias: Int! = aliases[objectIdentifier]
    if alias == nil {
      alias = nextAlias
      aliases[objectIdentifier] = nextAlias
      nextAlias = nextAlias + 1
    }
    return alias
  }

  // swiftlint:disable cyclomatic_complexity

  public func name(for object: AnyObject) -> String {
    let joiner = Joiner(left: "(", right: ")")

    joiner.append("0x\(String(alias(for: object), radix: 16).paddedWithZeros(to: 2))")

    var id: String?
    var className: String? = NSStringFromClass(type(of: object))
    //    #if os(iOS) || os(tvOS)
    //      switch object {
    //      case let view as UIView:
    //        if let accessibilityIdentifier = view.accessibilityIdentifier {
    //          id = "\"\(accessibilityIdentifier)\""
    //        }
    //
    //      case let barItem as UIBarItem:
    //        id = "\"\(barItem.accessibilityIdentifier†)\""
    //
    //      case let image as UIImage:
    //        id = "\"\(image.accessibilityIdentifier†)\""
    //
    //      default:
    //        break
    //      }
    //    #endif

    //    #if os(iOS) || os(tvOS) || os(macOS)
    //      switch object {
    //
    //      case let color as OSColor:
    //        className = "Color"
    //        id = color.debugSummary
    //
    //      case let font as OSFont:
    //        className = "Font"
    //        id = getID(for: font)
    //
    //      case let layoutConstraint as NSLayoutConstraint:
    //        if let identifier = layoutConstraint.identifier {
    //          id = "\"\(identifier)\""
    //        }
    //        if type(of: layoutConstraint) == NSLayoutConstraint.self {
    //          className = nil
    //        }
    //
    //      default:
    //        break
    //      }
    //    #endif

    switch object {
    case let number as NSNumber:
      className = nil
      id = getID(for: number)

    default:
      break
    }

    if let className = className {
      joiner.append(className)
    }

    if let id = id {
      joiner.append(id)
    }

    return joiner.description
  }

  // swiftlint:enable cyclomatic_complexity

  #if os(Linux)
  private func getID(for number: NSNumber) -> String {
    return String(describing: number)
  }
  #else
  private func getID(for number: NSNumber) -> String {
    if CFGetTypeID(number) == CFBooleanGetTypeID() {
      return number as! Bool ? "true" : "false"
    } else {
      return String(describing: number)
    }
  }

  //  private func getID(for font: OSFont) -> String {
  //    let idJoiner = Joiner()
  //    idJoiner.append("\"\(font.familyName)\"")
  //    if font.isBold {
  //      idJoiner.append("bold")
  //    }
  //    if font.isItalic {
  //      idJoiner.append("italic")
  //    }
  //    idJoiner.append(font.pointSize)
  //    return idJoiner.description
  //  }
  #endif
}

