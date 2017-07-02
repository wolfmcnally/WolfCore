//
//  AttributedStringExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

import WolfBase

extension NSAttributedString {
  public func height(forWidth width: CGFloat, context: NSStringDrawingContext? = nil) -> CGFloat {
    let maxBounds = CGSize(width: width, height: .greatestFiniteMagnitude)
    let bounds = boundingRect(with: maxBounds, options: [.usesLineFragmentOrigin], context: context)
    return ceil(bounds.height)
  }

  public func width(forHeight height: CGFloat, context: NSStringDrawingContext? = nil) -> CGFloat {
    let maxBounds = CGSize(width: .greatestFiniteMagnitude, height: height)
    let bounds = boundingRect(with: maxBounds, options: [.usesLineFragmentOrigin], context: context)
    return ceil(bounds.width)
  }
}

extension AttributedString {
  public var font: OSFont {
    get { return substring().font }
    set { substring().font = newValue }
  }

  public var foregroundColor: OSColor {
    get { return substring().foregroundColor }
    set { substring().foregroundColor = newValue }
  }

  public var paragraphStyle: NSMutableParagraphStyle {
    get { return substring().paragraphStyle }
    set { substring().paragraphStyle = newValue }
  }

  public var textAlignment: NSTextAlignment {
    get { return substring().textAlignment }
    set { substring().textAlignment = newValue }
  }
}
