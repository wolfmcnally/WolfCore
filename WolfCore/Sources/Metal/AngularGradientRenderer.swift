//
//  AngularGradientRenderer.swift
//  AngularGradientShader
//
//  Created by Wolf McNally on 8/5/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase
import Metal
import CoreGraphics
import UIKit
import simd

public struct GradientElement {
  public var color: float4
  public var frac: Float
  public var bias: Float

  public init(color: float4, frac: Float, bias: Float = 0.5) {
    self.color = color
    self.frac = frac
    self.bias = bias
  }

  public init(color: Color, frac: Float, bias: Float = 0.5) {
    self.init(color: float4(Float(color.red), Float(color.green), Float(color.blue), Float(color.alpha)), frac: frac, bias: bias)
  }
}

struct AngularGradientShaderParams {
  var center: float2
  var initialAngle: Float
  var innerRadius: Float
  var outerRadius: Float
  var isOpaque: Bool
  var isClockwise: Bool
  var isFlipped: Bool
  var elementsCount: Int32
}

public class AngularGradientRenderer {
  private let device: MTLDevice
  private let library: MTLLibrary
  private let shaderFunction: MTLFunction
  private let pipelineState: MTLComputePipelineState

  public init() {
    guard let dev = MTLCreateSystemDefaultDevice() else {
      fatalError("Metal not supported on this device.")
    }

    device = dev
    let libPath = Framework.bundle.path(forResource: "default", ofType: "metallib")!
    library = try! device.makeLibrary(filepath: libPath)
    shaderFunction = library.makeFunction(name: "angularGradientShader")!
    pipelineState = try! device.makeComputePipelineState(function: shaderFunction)
  }

  public func makeCGImage(size: CGFloat, gradient: [GradientElement], initialAngle: CGFloat = 0, innerRadius: CGFloat = 0, outerRadius: CGFloat = 0, isOpaque: Bool = false, isClockwise: Bool = true, isFlipped: Bool = false) -> CGImage {
    let width = Int(size)
    let height = Int(size)
    let halfSize = Float(size) / 2
    let center = float2(halfSize, halfSize)

    let elements = ContiguousArray(gradient)
    let elementsLength = MemoryLayout<GradientElement>.stride * elements.count
    let elementsBuffer = elements.withUnsafeBytes {
      return device.makeBuffer(bytes: $0.baseAddress!, length: elementsLength, options: [])
    }

    var params = AngularGradientShaderParams(center: center, initialAngle: Float(initialAngle), innerRadius: Float(innerRadius), outerRadius: Float(outerRadius), isOpaque: isOpaque, isClockwise: isClockwise, isFlipped: isFlipped, elementsCount: Int32(elements.count))
    let paramsBuffer = device.makeBuffer(bytes: &params, length: MemoryLayout<AngularGradientShaderParams>.stride, options: [])

    let commandQueue = device.makeCommandQueue()!
    let commandBuffer = commandQueue.makeCommandBuffer()!
    let commandEncoder = commandBuffer.makeComputeCommandEncoder()!

    let threadGroupsCount = MTLSizeMake(8, 8, 1)
    let blockWidth = Int(ceil(Float(width) / Float(threadGroupsCount.width)))
    let blockHeight = Int(ceil(Float(height) / Float(threadGroupsCount.height)))
    let threadGroups = MTLSizeMake(blockWidth, blockHeight, 1)

    let outTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
    outTextureDescriptor.usage = .shaderWrite
    let outTexture = device.makeTexture(descriptor: outTextureDescriptor)!

    commandEncoder.setComputePipelineState(pipelineState)
    commandEncoder.setTexture(outTexture, index: 0)
    commandEncoder.setBuffer(paramsBuffer, offset: 0, index: 0)
    commandEncoder.setBuffer(elementsBuffer, offset: 0, index: 1)

    commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupsCount)
    commandEncoder.endEncoding()

    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()

    return outTexture.makeImage()
  }

  public func makeImage(size: CGFloat, gradient: [GradientElement], initialAngle: CGFloat = 0, innerRadius: CGFloat = 0, outerRadius: CGFloat = 0, isOpaque: Bool = false, isClockwise: Bool = true, isFlipped: Bool = false) -> UIImage {
    let scale = UIScreen.main.scale
    let scaledSize = size * scale
    let scaledInnerRadius = innerRadius * scale
    let scaledOuterRadius = outerRadius * scale
    let cgImage = makeCGImage(size: scaledSize, gradient: gradient, initialAngle: initialAngle, innerRadius: scaledInnerRadius, outerRadius: scaledOuterRadius, isOpaque: isOpaque, isFlipped: isFlipped)
    return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
  }
}
