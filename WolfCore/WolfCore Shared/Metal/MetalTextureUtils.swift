//
//  MetalTextureUtils.swift
//  AngularGradientShader
//
//  Created by Wolf McNally on 8/5/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Metal
import CoreGraphics

extension MTLTexture {
    func makeImage() -> CGImage {
        assert(textureType == .type2D)

        let bitsPerComponent = 8
        let componentsPerPixel = 4
        let pixelBytesAlignment = 4

        let bitsPerPixel = bitsPerComponent * componentsPerPixel
        let bytesPerPixel = bitsPerPixel / bitsPerComponent

        let bytesPerRow = width * bytesPerPixel
        let pixelBytesCount = bytesPerRow * height

        let pixelBytes = UnsafeMutableRawPointer.allocate(bytes: pixelBytesCount, alignedTo: pixelBytesAlignment)
        defer { pixelBytes.deallocate(bytes: pixelBytesCount, alignedTo: pixelBytesAlignment) }

        let region = MTLRegionMake2D(0, 0, width, height)
        getBytes(pixelBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)

        let pixelData = Data(bytes: pixelBytes, count: pixelBytesCount)
        let provider = CGDataProvider(data: pixelData as CFData)!

        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)
        let image = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!

        return image
    }
}
