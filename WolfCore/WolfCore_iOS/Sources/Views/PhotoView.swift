//
//  PhotoView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class PhotoView: View {
  public private(set) var safeAreaView: PhotoSafeAreaView!
  
  public private(set) lazy var gradientView: GradientOverlayView = {
    let view = GradientOverlayView()
    return view
  }()
  
  public private(set) lazy var imageView: ImageView = {
    let view = ImageView()
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()
  
  open override func setup() {
    super.setup()
    isUserInteractionEnabled = false
    self => [
      imageView,
      gradientView
    ]
    imageView.constrainFrameToFrame()
    gradientView.constrainFrameToFrame()
    safeAreaView = PhotoSafeAreaView.addToView(view: self)
  }
  
  public var image: UIImage? {
    get { return imageView.image }
    set { imageView.image = newValue }
  }
  
  public var imageURL: URL? {
    get { return imageView.url }
    set { imageView.url = newValue }
  }
}
