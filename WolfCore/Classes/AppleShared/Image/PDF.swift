//
//  PDF.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/21/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public struct PDFReference: ExtensibleEnumeratedName, Reference {
    public let rawValue: String
    public let bundle: Bundle

    public init(_ rawValue: String, in bundle: Bundle? = nil) {
        self.rawValue = rawValue
        self.bundle = bundle ?? Bundle.main
    }

    // RawRepresentable
    public init?(rawValue: String) { self.init(rawValue) }

    // Reference
    public var referent: PDF {
        return PDF(named: rawValue, in: bundle)!
    }
}

public postfix func ® (lhs: PDFReference) -> PDF {
    return lhs.referent
}

public class PDF {
    private let pdf: CGPDFDocument
    public let pageCount: Int

    public init(url: URL) {
        pdf = CGPDFDocument(url as NSURL)!
        pageCount = pdf.numberOfPages
    }

    public convenience init?(named name: String, inSubdirectory subdirectory: String? = nil, in bundle: Bundle? = nil) {
        let bundle = bundle ?? Bundle.main
        if let url = bundle.url(forResource: name, withExtension: "pdf", subdirectory: subdirectory) {
            self.init(url: url)
        } else {
            return nil
        }
    }

    public init(data: Data) {
        let provider = CGDataProvider(data: data as NSData)!
        pdf = CGPDFDocument(provider)!
        pageCount = pdf.numberOfPages
    }

    public func getSize(ofPageAtIndex index: Int = 0) -> CGSize {
        return getSize(ofPage: getPage(atIndex: index))
    }

    #if os(iOS) || os(tvOS)
    public func getImage(forPageAtIndex index: Int = 0, size: CGSize? = nil, scale: CGFloat = 0.0, renderingMode: UIImageRenderingMode = .automatic) -> UIImage {
    let page = getPage(atIndex: index)
    let size = size ?? getSize(ofPageAtIndex: index)
    let bounds = CGRect(origin: .zero, size: size)
    let cropBox = page.getBoxRect(.cropBox)
    let scaling = CGVector(size: bounds.size) / CGVector(size: cropBox.size)
    let transform = CGAffineTransform(scaling: scaling)
    return newImage(withSize: size, isOpaque: false, scale: scale, isFlipped: true, renderingMode: renderingMode) { context in
    context.concatenate(transform)
    context.drawPDFPage(page)
    }
    }
    #endif

    #if os(iOS) || os(tvOS)
    public func getImage(forPageAtIndex index: Int = 0, fittingSize: CGSize, scale: CGFloat = 0.0, renderingMode: UIImageRenderingMode = .automatic) -> UIImage? {
    guard fittingSize.width > 0 || fittingSize.height > 0 else { return nil }
    let size = getSize(ofPageAtIndex: index)
    let newSize = size.aspectFit(within: fittingSize)
    return getImage(forPageAtIndex: index, size: newSize, scale: scale, renderingMode: renderingMode)
    }
    #endif

    #if os(iOS) || os(tvOS)
    public func getImage() -> UIImage {
    return getImage(forPageAtIndex: 0)
    }
    #endif

    //
    // MARK: - Private
    //

    private func getPage(atIndex index: Int) -> CGPDFPage {
        assert(index < pageCount)
        return pdf.page(at: index + 1)!
    }

    private func getSize(ofPage page: CGPDFPage) -> CGSize {
        var size = page.getBoxRect(.cropBox).size
        let rotationAngle = page.rotationAngle
        if rotationAngle == 90 || rotationAngle == 270 {
            size = size.swapped()
        }
        return size
    }
}

extension PDF: Serializable {
    public func serialize() -> Data {
        fatalError("PDFs may only be deserialized.")
    }

    public static func deserialize(from data: Data) throws -> PDF {
        return PDF(data: data)
    }
}
