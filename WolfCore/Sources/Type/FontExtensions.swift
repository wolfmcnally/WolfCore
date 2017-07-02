//
//  FontExtensions.swift
//  WolfCoreOS
//
//  Created by Wolf McNally on 6/22/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if os(macOS)
  import Cocoa
#else
  import UIKit
#endif

#if os(macOS)
  extension NSFont {
    public var isBold: Bool {
      return fontDescriptor.symbolicTraits.contains(.bold)
    }
    
    public var isItalic: Bool {
      return fontDescriptor.symbolicTraits.contains(.italic)
    }
    
    public var plainVariant: NSFont {
      return NSFont(descriptor: fontDescriptor.withSymbolicTraits([]), size: 0)!
    }
    
    public var boldVariant: NSFont {
      return NSFont(descriptor: fontDescriptor.withSymbolicTraits([.bold]), size: 0)!
    }
    
    public var italicVariant: NSFont {
      return NSFont(descriptor: fontDescriptor.withSymbolicTraits([.italic]), size: 0)!
    }
  }
#else
  extension UIFont {
    public var isBold: Bool {
      return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    public var isItalic: Bool {
      return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    public var plainVariant: UIFont {
      return UIFont(descriptor: fontDescriptor.withSymbolicTraits([])!, size: 0)
    }
    
    public var boldVariant: UIFont {
      return UIFont(descriptor: fontDescriptor.withSymbolicTraits([.traitBold])!, size: 0)
    }
    
    public var italicVariant: UIFont {
      return UIFont(descriptor: fontDescriptor.withSymbolicTraits([.traitItalic])!, size: 0)
    }
  }
#endif

