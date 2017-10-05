//
//  OSImage.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

#if os(macOS)
  import Cocoa
#elseif !os(Linux)
  import UIKit
#endif

#if os(macOS)
  extension NSImage {
    public convenience init(cgImage: CGImage, scale: CGFloat, orientation: OSImageOrientation) {
      self.init(cgImage: cgImage, size: .zero)
    }
    public var cgImage: CGImage? {
      return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    var scale: CGFloat { return 1.0 }
    var renderingMode: OSImageRenderingMode { return .automatic }
    var imageOrientation: OSImageOrientation { return .up }
  }
#endif

public typealias ImageBlock = (OSImage) -> Void
public typealias ImagePromise = Promise<OSImage>
