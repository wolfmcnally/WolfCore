//
//  OSImageOrientation.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com.
//

#if os(macOS)
    public enum OSImageOrientation: Int {
        case up
        case down
        case left
        case right
        case upMirrored
        case downMirrored
        case leftMirrored
        case rightMirrored
    }
#elseif canImport(UIKit)
    import UIKit
public typealias OSImageOrientation = UIImage.Orientation
#endif
