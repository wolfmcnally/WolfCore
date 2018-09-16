//
//  ImageView.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/8/15.
//  Copyright © 2015 WolfMcNally.com.
//

import UIKit

public var sharedImageCache: Cache<UIImage>! = Cache<UIImage>(filename: "sharedImageCache", sizeLimit: 100000, includeHTTP: true)
public var sharedDataCache: Cache<Data>! = Cache<Data>(filename: "sharedDataCache", sizeLimit: 100000, includeHTTP: true)

public typealias ImageViewBlock = (ImageView) -> Void
public typealias ImageProcessingBlock = (UIImage) -> UIImage

open class ImageView: UIImageView {
    public var isTransparentToTouches = false
    //private var updatePDFCanceler: Cancelable?
    private var retrievePromise: Cancelable?
    public var onRetrieveStart: ImageViewBlock?
    public var onRetrieveSuccess: ImageViewBlock?
    public var onRetrieveFailure: ImageViewBlock?
    public var onRetrieveFinally: ImageViewBlock?
    public var onPostprocessImage: ImageProcessingBlock?

    open override var image: UIImage? {
        get {
            return super.image
        }

        set {
            if let image = newValue, let onPostprocessImage = onPostprocessImage {
                super.image = onPostprocessImage(image)
            } else {
                super.image = newValue
            }
        }
    }

    public var pdfTintColor: UIColor? {
        didSet {
            //updatePDFImage()
            setNeedsLayout()
        }
    }

    public var pdf: PDF? {
        didSet {
            //updatePDFImage()
            setNeedsLayout()
        }
    }

    public var url: URL? {
        didSet {
            retrievePromise?.cancel()
            self.retrievePromise = nil
            self.pdf = nil
            self.image = nil
            guard let url = self.url else { return }
            self.onRetrieveStart?(self)
            if url.absoluteString.hasSuffix("pdf") {
                self.retrievePromise = sharedDataCache.retrieveObject(for: url).then { data in
                    self.pdf = PDF(data: data)
                    self.onRetrieveSuccess?(self)
                    }.catch { _ in
                        self.onRetrieveFailure?(self)
                    }.run { _ in
                        self.onRetrieveFinally?(self)
                        self.retrievePromise = nil
                }
            } else {
                self.retrievePromise = sharedImageCache.retrieveObject(for: url).then { image in
                    self.image = image
                    self.onRetrieveSuccess?(self)
                    }.catch { _ in
                        self.onRetrieveFailure?(self)
                    }.run { _ in
                        self.onRetrieveFinally?(self)
                        self.retrievePromise = nil
                }
            }
        }
    }

    private var lastFittingSize: CGSize?
    private weak var lastPDF: PDF?

    private func updatePDFImage() {
        guard let pdf = pdf else { return }

        let fittingSize = bounds.size
        if lastFittingSize != fittingSize || lastPDF !== pdf {
            var newImage = pdf.getImage(fittingSize: fittingSize)
            if let pdfTintColor = pdfTintColor {
                newImage = newImage?.tinted(withColor: pdfTintColor)
            }
            self.image = newImage
            lastFittingSize = fittingSize
            lastPDF = pdf
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePDFImage()
    }

    //    open override func layoutSubviews() {
    //        updatePDFCanceler?.cancel()
    //        lastFittingSize = nil
    //        if pdf != nil {
    //            updatePDFCanceler = dispatchOnMain(afterDelay: 0.1) {
    //                self.updatePDFImage()
    //            }
    //        }
    //        super.layoutSubviews()
    //    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        lastFittingSize = nil
    }

    //    open override var intrinsicContentSize: CGSize {
    //        let size: CGSize
    //        if let pdf = pdf {
    //            size = pdf.getSize()
    //        } else {
    //            size = super.intrinsicContentSize
    //        }
    //        return size
    //    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }

    public override init(image: UIImage?) {
        super.init(image: image)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    private func _setup() {
        __setup()
        setup()
    }

    open func setup() { }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }
}
