//
//  FontDebugging.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com.
//

#if canImport(AppKit)
    import AppKit
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
