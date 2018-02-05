//
//  FontFamilyName.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//


public struct FontFamilyName: ExtensibleEnumeratedName {
    public let rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }
}
