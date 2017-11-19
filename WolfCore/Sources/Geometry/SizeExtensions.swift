//
//  SizeExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/21/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation
import CoreGraphics
import WolfBase

#if os(iOS) || os(tvOS)
    import UIKit
#endif

#if os(iOS) || os(tvOS)
    public let noSize = UIViewNoIntrinsicMetric
#else
    public let noSize: CGFloat = -1.0
#endif

extension CGSize {
    public static var none = CGSize(width: noSize, height: noSize)

    public init(vector: CGVector) {
        width = vector.dx
        height = vector.dy
    }

    public var aspect: CGFloat {
        return width / height
    }

    public func scaleForAspectFit(within size: CGSize) -> CGFloat {
        if size.width != noSize && size.height != noSize {
            return Swift.min(size.width / width, size.height / height)
        } else if size.width != noSize {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func scaleForAspectFill(within size: CGSize) -> CGFloat {
        if size.width != noSize && size.height != noSize {
            return Swift.max(size.width / width, size.height / height)
        } else if size.width != noSize {
            return size.width / width
        } else {
            return 1.0
        }
    }

    public func aspectFit(within size: CGSize) -> CGSize {
        let scale = scaleForAspectFit(within: size)
        return CGSize(vector: CGVector(size: self) * scale)
    }

    public func aspectFill(within size: CGSize) -> CGSize {
        let scale = scaleForAspectFill(within: size)
        return CGSize(vector: CGVector(size: self) * scale)
    }

    public var max: CGFloat {
        return Swift.max(width, height)
    }

    public var min: CGFloat {
        return Swift.min(width, height)
    }

    public func swapped() -> CGSize {
        return CGSize(width: height, height: width)
    }

    public var bounds: CGRect {
        return CGRect(origin: .zero, size: self)
    }
}

extension CGSize {
    public var isLandscape: Bool {
        return width > height
    }

    public var isPortrait: Bool {
        return height > width
    }

    public var isSquare: Bool {
        return width == height
    }

    public var debugSummary: String {
        let joiner = Joiner(left: "(", right: ")")
        joiner.append(width %% 3, height %% 3)
        return joiner.description
    }
}

public func + (left: CGSize, right: CGSize) -> CGVector {
    return CGVector(dx: left.width + right.width, dy: left.height + right.height)
}

public func - (left: CGSize, right: CGSize) -> CGVector {
    return CGVector(dx: left.width - right.width, dy: left.height - right.height)
}

public func + (left: CGSize, right: CGVector) -> CGSize {
    return CGSize(width: left.width + right.dx, height: left.height + right.dy)
}

public func - (left: CGSize, right: CGVector) -> CGSize {
    return CGSize(width: left.width - right.dx, height: left.height - right.dy)
}

public func + (left: CGVector, right: CGSize) -> CGSize {
    return CGSize(width: left.dx + right.width, height: left.dy + right.height)
}

public func - (left: CGVector, right: CGSize) -> CGSize {
    return CGSize(width: left.dx - right.width, height: left.dy - right.height)
}

public func * (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}
