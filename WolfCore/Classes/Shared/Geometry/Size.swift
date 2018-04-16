//
//  Size.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/15/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

#if canImport(CoreGraphics)
    import CoreGraphics
#endif

public struct Size: Codable {
    public var width: Double = 0
    public var height: Double = 0

    public static let None = -1.0

    public init() {
        width = 0.0
        height = 0.0
    }

    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}

#if !os(Linux)
    extension Size {
        public init(s: CGSize) {
            width = Double(s.width)
            height = Double(s.height)
        }

        public var cgSize: CGSize {
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }
    }
#endif

extension Size {
    public init(vector: Vector) {
        width = vector.dx
        height = vector.dy
    }

    public var aspect: Double {
        return width / height
    }

    public func scaleForAspectFit(within size: Size) -> Double {
        if size.width != Size.None && size.height != Size.None {
            return Swift.min(size.width / width, size.height / height)
        } else if size.width != Size.None {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func scaleForAspectFill(within size: Size) -> Double {
        if size.width != Size.None && size.height != Size.None {
            return Swift.max(size.width / width, size.height / height)
        } else if size.width != Size.None {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func aspectFit(within size: Size) -> Size {
        let scale = scaleForAspectFit(within: size)
        return Size(vector: Vector(size: self) * scale)
    }

    public func aspectFill(within size: Size) -> Size {
        let scale = scaleForAspectFill(within: size)
        return Size(vector: Vector(size: self) * scale)
    }

    public var max: Double {
        return Swift.max(width, height)
    }

    public var min: Double {
        return Swift.min(width, height)
    }
}

extension Size: CustomStringConvertible {
    public var description: String {
        return("Size(\(width), \(height))")
    }
}

extension Size {
    public static let zero = Size()
    public static let infinite = Size(width: Double.infinity, height: Double.infinity)

    public init(width: Int, height: Int) {
        self.width = Double(width)
        self.height = Double(height)
    }

    public init(width: Float, height: Float) {
        self.width = Double(width)
        self.height = Double(height)
    }
}

extension Size: Equatable {
}

public func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

extension Size {
    public var isEmpty: Bool { return width == 0.0 || height == 0.0 }
}

public func * (lhs: Size, rhs: Double) -> Size {
    return Size(width: lhs.width * rhs, height: lhs.height * rhs)
}

public func / (lhs: Size, rhs: Double) -> Size {
    return Size(width: lhs.width / rhs, height: lhs.height / rhs)
}
