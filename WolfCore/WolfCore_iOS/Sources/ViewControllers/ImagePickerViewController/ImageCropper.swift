//
//  ImageCropper.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/21/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public var imageCropperType: ImageCropper.Type!

public protocol ImageCropper: class {
    typealias ResponseBlock = (_ croppedImage: UIImage, _ usingCropRect: CGRect) -> Void
    init(image originalImage: UIImage)
    var avoidEmptySpaceAroundImage: Bool { get set }
    var cropperViewController: UIViewController { get }
    var onDidCancel: Block? { get set }
    var onDidCrop: ResponseBlock? { get set }
}

public func newImageCropper(with image: UIImage) -> ImageCropper {
    return imageCropperType.init(image: image)
}
