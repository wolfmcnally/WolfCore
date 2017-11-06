//
//  ImageViewerViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/19/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class ImageViewerViewController: ViewController {
    public let sourceImageView: UIImageView
    private var doneAction: BarButtonItemAction!
    private var tapAction: GestureRecognizerAction!
    private var doubleTapAction: GestureRecognizerAction!
    var dismissAction: GestureRecognizerAction!
    private var chromeHidden = false
    private var willDismissAction: Block?
    private var navbarTitle: String!
    
    public var image: UIImage {
        guard sourceImageView.image != nil else {
            return UIImage()
        }
        return sourceImageView.image!
    }
    
    public static func present(with sourceImageView: UIImageView, from presentingViewController: UIViewController, navbarTitle: String = "Photo"¶, willDismissAction: Block? = nil) {
        let viewController = ImageViewerViewController(with: sourceImageView)
        viewController.navbarTitle = navbarTitle
        viewController.willDismissAction = willDismissAction
        viewController.present(from: presentingViewController, animated: true, completion: nil)
    }
    
    public init(with sourceImageView: UIImageView) {
        self.sourceImageView = sourceImageView
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private lazy var imageView: ImageView = .init()
    
    public var imageViewFrame: CGRect {
        view.layoutIfNeeded()
        return view.convert(imageView.frame, from: imageView.superview!)
    }
    
    lazy var contentView: View = {
        let view = View()
        return view
    }()
    
    lazy var scrollView: ScrollView = {
        let view = ScrollView()
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 4.0
        view.scrollsToTop = false
        view.alwaysBounceHorizontal = true
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    private func present(from presentingViewController: UIViewController, animated: Bool, completion: Block?) {
        let navController = NavigationController(rootViewController: self)
        navController.transitioningDelegate = self
        navController.modalPresentationStyle = .custom
        presentingViewController.present(navController, animated: animated, completion: completion)
    }
    
    // view
    //   scrollView
    //     contentView
    //       imageView
    //         image
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupSubviews()
        setupGestures()
    }
    
    private func setupNavigationItem() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done)
        doneAction = doneItem.addAction { [unowned self] in
            self.dismiss()
        }
        navigationItem.leftBarButtonItem = doneItem
        navigationItem.title = navbarTitle
    }
    
    private func setupSubviews() {
        view => [
            scrollView => [
                contentView => [
                    imageView
                ]
            ]
        ]
        
        scrollView.constrainFrameToFrame()
        
        contentView.constrainFrameToFrame()
        
        imageView.constrainCenterToCenter()
        Constraints(
            imageView.widthAnchor <= contentView.widthAnchor,
            imageView.heightAnchor <= contentView.heightAnchor,
            imageView.widthAnchor == contentView.widthAnchor =&= .defaultHigh,
            imageView.heightAnchor == contentView.heightAnchor =&= .defaultHigh,
            imageView.widthAnchor == imageView.heightAnchor * image.size.aspect
        )
        
        imageView.image = image
        
        Constraints(
            contentView.widthAnchor == view.widthAnchor,
            contentView.heightAnchor == view.heightAnchor
        )
    }
    
    public var isImageViewHidden: Bool = false {
        didSet {
            imageView.hideIf(isImageViewHidden)
        }
    }
    
    private func setupGestures() {
        let singleTapRecognizer = UITapGestureRecognizer()
        tapAction = view.addAction(forGestureRecognizer: singleTapRecognizer) { [unowned self] _ in
            self.toggleChrome(animated: true)
        }
        
        let doubleTapRecognizer = UITapGestureRecognizer()
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapAction = view.addAction(forGestureRecognizer: doubleTapRecognizer) { [unowned self] recognizer in
            let p = recognizer.location(in: self.contentView)
            self.toggleZoom(animated: true, focusPoint: p)
        }
        
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        
        let dismissRecognizer = ImageViewerDismissGestureRecognizer()
        dismissRecognizer.delegate = self
        dismissAction = view.addAction(forGestureRecognizer: dismissRecognizer) { [unowned self] recognizer in
            self.dismiss()
        }
    }
    
    private func toggleChrome(animated: Bool) {
        if chromeHidden {
            showChrome(animated: animated)
        } else {
            hideChrome(animated: animated)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIViewController.attemptRotationToDeviceOrientation()
        
        hideChrome(animated: animated)
    }
    
    public override var prefersStatusBarHidden: Bool {
        return chromeHidden ? true : super.prefersStatusBarHidden
    }
    
    private func hideChrome(animated: Bool) {
        chromeHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        dispatchAnimated(animated) {
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.backgroundColor = .black
            }.run()
    }
    
    private func showChrome(animated: Bool) {
        chromeHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        dispatchAnimated(animated) {
            self.setNeedsStatusBarAppearanceUpdate()
            //            self.view.backgroundColor = .white
            }.run()
    }
    
    private func toggleZoom(animated: Bool, focusPoint point: CGPoint) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            zoomOut(animated: animated)
        } else {
            zoomIn(animated: animated, focusPoint: point)
        }
    }
    
    private func zoomOut(animated: Bool) {
        scrollView.zoom(to: contentView.bounds, animated: animated)
    }
    
    private func zoomIn(animated: Bool, focusPoint point: CGPoint) {
        let rect = CGRect(origin: point, size: .zero)
        scrollView.zoom(to: rect, animated: animated)
    }
    
    public override func dismiss() {
        willDismissAction?()
        super.dismiss()
    }
}

extension ImageViewerViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    }
}

extension ImageViewerViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if dismissAction.gestureRecognizer == gestureRecognizer && otherGestureRecognizer == scrollView.panGestureRecognizer {
            return true
        }
        return false
    }
}

extension ImageViewerViewController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewerPresentationTransitioning()
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewerDismissalTransitioning()
    }
}

extension UIViewController {
    public func presentImageViewer(with sourceImageView: UIImageView) {
        ImageViewerViewController.present(with: sourceImageView, from: self)
    }
}
