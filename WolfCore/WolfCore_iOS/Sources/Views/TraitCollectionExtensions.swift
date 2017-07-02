//
//  TraitCollectionExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/11/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UIUserInterfaceSizeClass: CustomStringConvertible {
  public var description: String {
    switch self {
    case .unspecified: return "unspecified"
    case .compact: return "compact"
    case .regular: return "regular"
    }
  }
}
public func + (lhs: UITraitCollection, rhs: UITraitCollection) -> UITraitCollection {
  return UITraitCollection(traitsFrom: [lhs, rhs])
}

extension UITraitCollection {
  public static var HCompact: UITraitCollection {
    return UITraitCollection(horizontalSizeClass: .compact)
  }
  
  public static var HAny: UITraitCollection {
    return UITraitCollection(horizontalSizeClass: .unspecified)
  }
  
  public static var HRegular: UITraitCollection {
    return UITraitCollection(horizontalSizeClass: .regular)
  }
  
  
  public static var VCompact: UITraitCollection {
    return UITraitCollection(verticalSizeClass: .compact)
  }
  
  public static var VAny: UITraitCollection {
    return UITraitCollection(verticalSizeClass: .unspecified)
  }
  
  public static var VRegular: UITraitCollection {
    return UITraitCollection(verticalSizeClass: .regular)
  }
  
  
  // FINAL VALUES
  // For 3.5-inch, 4-inch, and 4.7-inch iPhones in landscape.
  public static var HCompactVCompact: UITraitCollection {
    return UITraitCollection.HCompact + UITraitCollection.VCompact
  }
  
  // BASE VALUES
  // For all compact height layouts, e.g., iPhones in landscape.
  public static var HAnyVCompact: UITraitCollection {
    return UITraitCollection.HAny + UITraitCollection.VCompact
  }
  
  // FINAL VALUES
  // for 5.5-inch iPhone in landscape.
  public static var HRegularVCompact: UITraitCollection {
    return UITraitCollection.HRegular + UITraitCollection.VCompact
  }
  
  
  // BASE VALUES
  // For all compact width layouts, e.g. 3.5-inch, 4-inch, and 4.7-inch iPhones in portrait or landscape.
  public static var HCompactVAny: UITraitCollection {
    return UITraitCollection.HCompact + UITraitCollection.VAny
  }
  
  // BASE VALUES
  // For all layouts.
  public static var HAnyVAny: UITraitCollection {
    return UITraitCollection.HAny + UITraitCollection.VAny
  }
  
  // BASE VALUES
  // For all regular width layouts, e.g. iPads in portrait or landscape.
  public static var HRegularVAny: UITraitCollection {
    return UITraitCollection.HRegular + UITraitCollection.VAny
  }
  
  
  // FINAL VALUES
  // For all iPhones in portrait.
  public static var HCompactVRegular: UITraitCollection {
    return UITraitCollection.HCompact + UITraitCollection.VRegular
  }
  
  // BASE VALUES
  // For all regular height layouts, e.g. iPhones in portrait and iPads in portrait or landscape.
  public static var HAnyVRegular: UITraitCollection {
    return UITraitCollection.HAny + UITraitCollection.VRegular
  }
  
  // FINAL VALUES
  // For iPads in portrait or landscape.
  public static var HRegularVRegular: UITraitCollection {
    return UITraitCollection.HRegular + UITraitCollection.VRegular
  }
}
