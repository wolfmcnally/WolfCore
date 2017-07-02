//
//  ImageViewerDismissalTransitioning.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/26/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//


import UIKit
import WolfBase

class ImageViewerDismissalTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return defaultAnimationDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! UINavigationController
    let viewerViewController = fromViewController.viewControllers[0] as! ImageViewerViewController
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
    
    let sourcePriorAlpha = viewerViewController.sourceImageView.alpha
    viewerViewController.sourceImageView.alpha = 0.0
    
    fromView.alpha = 1.0
    viewerViewController.isImageViewHidden = true
    
    let movingImageViewStartFrame = viewerViewController.view.convert(viewerViewController.imageViewFrame, to: containerView)
    
    let movingImageViewEndFrame = viewerViewController.sourceImageView.superview!.convert(viewerViewController.sourceImageView.frame, to: containerView)
    
    let movingImageView = UIImageView()
    movingImageView.contentMode = .scaleAspectFit
    movingImageView.image = viewerViewController.image
    movingImageView.frame = movingImageViewStartFrame
    
    containerView => [
      movingImageView
    ]
    
    dispatchAnimated(duration: transitionDuration(using: transitionContext)) {
      fromView.alpha = 0.0
      movingImageView.frame = movingImageViewEndFrame
      }.then { _ in
        viewerViewController.sourceImageView.alpha = sourcePriorAlpha
        movingImageView.removeFromSuperview()
        viewerViewController.isImageViewHidden = false
        let cancelled = transitionContext.transitionWasCancelled
        transitionContext.completeTransition(!cancelled)
      }.run()
  }
}
