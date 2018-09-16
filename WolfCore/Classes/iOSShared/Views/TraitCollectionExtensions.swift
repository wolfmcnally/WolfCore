//
//  TraitCollectionExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/11/15.
//  Copyright © 2015 WolfMcNally.com.
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
    public enum Trait {
        case userInterfaceIdiom(UIUserInterfaceIdiom)

        case displayScale(CGFloat)

        case horizontalSizeClass(UIUserInterfaceSizeClass)

        case verticalSizeClass(UIUserInterfaceSizeClass)

        case forceTouchCapability(UIForceTouchCapability)

        @available(iOS 10.0, *)
        case layoutDirection(UITraitEnvironmentLayoutDirection)

        @available(iOS 10.0, *)
        case preferredContentSizeCategory(UIContentSizeCategory)

        @available(iOS 10.0, *)
        case displayGamut(UIDisplayGamut)
    }

    /// Returns a new trait collection containing single specified trait
    ///
    /// - Parameter trait: A Trait value specifying the trait for the new trait collection
    public convenience init(trait: Trait) {
        switch trait {
        case let .userInterfaceIdiom(value):
            self.init(userInterfaceIdiom: value)
        case let .displayScale(value):
            self.init(displayScale: value)
        case let .horizontalSizeClass(value):
            self.init(horizontalSizeClass: value)
        case let .verticalSizeClass(value):
            self.init(verticalSizeClass: value)
        case let .forceTouchCapability(value):
            self.init(forceTouchCapability: value)
        case let .layoutDirection(value):
            if #available(iOS 10.0, *) {
                self.init(layoutDirection: value)
            } else {
                preconditionFailure("layoutDirection trait not available on this platform")
            }
        case let .preferredContentSizeCategory(value):
            if #available(iOS 10.0, *) {
                self.init(preferredContentSizeCategory: value)
            } else {
                preconditionFailure("preferredContentSizeCategory trait not available on this platform")
            }
        case let .displayGamut(value):
            if #available(iOS 10.0, *) {
                self.init(displayGamut: value)
            } else {
                preconditionFailure("displayGamut trait not available on this platform")
            }
        }
    }

    /// Returns a new trait collection consisting of traits merged from a specified array of traits
    ///
    /// - Parameter entities: An array of Trait values
    public convenience init<S>(traits: S) where S: Sequence, S.Iterator.Element == Trait {
        self.init(traitsFrom: traits.map(UITraitCollection.init(trait:)))
    }
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
