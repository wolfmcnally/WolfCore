//
//  ImageViewerPresentationTransitioning.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/25/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

class ImageViewerPresentationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return defaultAnimationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! UINavigationController
    let viewerViewController = toViewController.viewControllers[0] as! ImageViewerViewController
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
    
    let sourcePriorAlpha = viewerViewController.sourceImageView.alpha
    viewerViewController.sourceImageView.alpha = 0.0
    
    toView.alpha = 0.0
    viewerViewController.isImageViewHidden = true
    
    let movingImageViewStartFrame = viewerViewController.sourceImageView.superview!.convert(viewerViewController.sourceImageView.frame, to: containerView)
    
    let movingImageViewEndFrame = viewerViewController.view.convert(viewerViewController.imageViewFrame, to: containerView)
    
    let movingImageView = UIImageView()
    movingImageView.contentMode = .scaleAspectFit
    movingImageView.image = viewerViewController.image
    movingImageView.frame = movingImageViewStartFrame
    
    containerView => [
      toView,
      movingImageView
    ]
    
    dispatchAnimated( duration: transitionDuration(using: transitionContext) ) {
      toView.alpha = 1.0
      movingImageView.frame = movingImageViewEndFrame
      }.then { _ in
        movingImageView.removeFromSuperview()
        viewerViewController.isImageViewHidden = false
        viewerViewController.sourceImageView.alpha = sourcePriorAlpha
        let cancelled = transitionContext.transitionWasCancelled
        transitionContext.completeTransition(!cancelled)
      }.run()
  }
}
