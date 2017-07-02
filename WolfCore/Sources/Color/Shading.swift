//
//  Shading.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/13/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import CoreGraphics
import WolfBase

public class Shading {
  public typealias CallbackBlock = (_ frac: Frac) -> Color
  private typealias `Self` = Shading
  
  public private(set) var cgShading: CGShading!
  let callback: CallbackBlock
  let numComponents = sharedColorSpaceRGB.numberOfComponents + 1
  
  public init(start: CGPoint, startRadius: CGFloat, end: CGPoint, endRadius: CGFloat, extendStart: Bool = false, extendEnd: Bool = false, using callback: @escaping CallbackBlock) {
    self.callback = callback
    var callbacks = CGFunctionCallbacks(version: 0, evaluate: { (info, inData, outData) in
      let me = Unmanaged<Self>.fromOpaque(info!).takeUnretainedValue()
      let frac = Frac(inData[0])
      let color = me.callback(frac)
      let components = color.cgColor.components!
      for i in 0 ..< me.numComponents {
        outData[i] = components[i]
      }
    }, releaseInfo: nil)
    let function = CGFunction(info: Unmanaged.passUnretained(self).toOpaque(), domainDimension: 1, domain: [0, 1], rangeDimension: numComponents, range: [0, 1, 0, 1, 0, 1, 0, 1], callbacks: &callbacks)!
    cgShading = CGShading(radialSpace: sharedColorSpaceRGB, start: start, startRadius: startRadius, end: end, endRadius: endRadius, function: function, extendStart: extendStart, extendEnd: extendEnd)!
  }
  
  public init(start: CGPoint, end: CGPoint, extendStart: Bool = false, extendEnd: Bool = false, using callback: @escaping CallbackBlock) {
    self.callback = callback
    var callbacks = CGFunctionCallbacks(version: 0, evaluate: { (info, inData, outData) in
      let me = Unmanaged<Self>.fromOpaque(info!).takeUnretainedValue()
      let frac = Frac(inData[0])
      let color = me.callback(frac)
      let components = color.cgColor.components!
      for i in 0 ..< me.numComponents {
        outData[i] = components[i]
      }
    }, releaseInfo: nil)
    let function = CGFunction(info: Unmanaged.passUnretained(self).toOpaque(), domainDimension: 1, domain: [0, 1], rangeDimension: numComponents, range: [0, 1, 0, 1, 0, 1, 0, 1], callbacks: &callbacks)!
    cgShading = CGShading(axialSpace: sharedColorSpaceRGB, start: start, end: end, function: function, extendStart: extendStart, extendEnd: extendEnd)
  }
}

extension CGContext {
  public func drawShading(_ shading: Shading) {
    drawShading(shading.cgShading)
  }
}
