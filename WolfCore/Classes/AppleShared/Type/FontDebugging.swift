//
//  FontDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(Cocoa)
    import Cocoa
#elseif canImport(UIKit)
    import UIKit
#endif

public func printFontNames() {
    for family in OSFont.familyNames {
        print("")
        print("\(family)")
        for fontName in OSFont.fontNames(forFamilyName: family) {
            print("\(fontName)".indented())
        }
    }
}
