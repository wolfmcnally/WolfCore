//
//  AutolayoutUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif
//
//extension LayoutPriority: Comparable {
//    public static func == (lhs: LayoutPriority, rhs: LayoutPriority) -> Bool {
//        return lhs.rawValue == rhs.rawValue
//    }
//
//    public static func < (lhs: LayoutPriority, rhs: LayoutPriority) -> Bool {
//        return lhs.rawValue < rhs.rawValue
//    }
//}

public func + (lhs: LayoutPriority, rhs: Float) -> LayoutPriority {
    return LayoutPriority(rawValue: lhs.rawValue + rhs)
}

public func - (lhs: LayoutPriority, rhs: Float) -> LayoutPriority {
    return LayoutPriority(rawValue: lhs.rawValue - rhs)
}

extension OSView {
    private func checkTargetView(view: OSView?) -> OSView {
        guard let view = view ?? superview else {
            fatalError("View must have a superview.")
        }
        return view
    }

    @discardableResult public func pinFrame(to view: OSView? = nil, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           leadingAnchor == view.leadingAnchor + frame.minX =&= priority =%= [identifier, "leading"],
                           topAnchor == view.topAnchor + frame.minY =&= priority =%= [identifier, "top"],
                           widthAnchor == frame.width =&= priority =%= [identifier, "width"],
                           heightAnchor == frame.height =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func pinSize(priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor == frame.width =&= priority =%= [identifier, "width"],
                           heightAnchor == frame.height =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func constrainFrameToFrame(of view: OSView? = nil, topAnchor viewTopAnchor: NSLayoutYAxisAnchor? = nil, bottomAnchor viewBottomAnchor: NSLayoutYAxisAnchor? = nil, insets: CGInsets = .zero, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        let viewTopAnchor = viewTopAnchor ?? view.topAnchor
        let viewBottomAnchor = viewBottomAnchor ?? view.bottomAnchor
        var constraints = [NSLayoutConstraint]()
        if let 🍒 = insets.left { constraints.append(leadingAnchor == view.leadingAnchor + 🍒 =&= priority =%= [identifier, "leading"]) }
        if let 🍒 = insets.right { constraints.append(trailingAnchor == view.trailingAnchor - 🍒 =&= priority =%= [identifier, "trailing"]) }
        if let 🍒 = insets.top { constraints.append(topAnchor == viewTopAnchor + 🍒 =&= priority =%= [identifier, "top"]) }
        if let 🍒 = insets.bottom { constraints.append(bottomAnchor == viewBottomAnchor - 🍒 =&= priority =%= [identifier, "bottom"]) }
        return Constraints(activate: activate, identifier: identifier, constraints)
    }

    #if os(iOS) || os(tvOS)
    @available(iOS 11.0, *)
    @discardableResult public func constrainFrameToSafeArea(of view: OSView? = nil, topAnchor viewTopAnchor: NSLayoutYAxisAnchor? = nil, bottomAnchor viewBottomAnchor: NSLayoutYAxisAnchor? = nil, insets: CGInsets = .zero, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let viewTopAnchor = viewTopAnchor ?? safeAreaLayoutGuide.topAnchor
        let viewBottomAnchor = viewBottomAnchor ?? safeAreaLayoutGuide.bottomAnchor
        var constraints = [NSLayoutConstraint]()
        if let 🍒 = insets.left { constraints.append(leadingAnchor == safeAreaLayoutGuide.leadingAnchor + 🍒 =&= priority =%= [identifier, "leading"]) }
        if let 🍒 = insets.right { constraints.append(trailingAnchor == safeAreaLayoutGuide.trailingAnchor - 🍒 =&= priority =%= [identifier, "trailing"]) }
        if let 🍒 = insets.top { constraints.append(topAnchor == viewTopAnchor + 🍒 =&= priority =%= [identifier, "top"]) }
        if let 🍒 = insets.bottom { constraints.append(bottomAnchor == viewBottomAnchor - 🍒 =&= priority =%= [identifier, "bottom"]) }
        return Constraints(activate: activate, identifier: identifier, constraints)
    }
    #endif

    @discardableResult public func constrainCenter(to point: CGPoint, of view: OSView? = nil, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           centerXAnchor == view.leadingAnchor + point.x =&= priority =%= [identifier, "centerX"],
                           centerYAnchor == view.topAnchor + point.y =&= priority =%= [identifier, "centerY"]
        )
    }

    @discardableResult public func constrainCenterToCenter(of view: OSView? = nil, offsets: CGVector = .zero, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           centerXAnchor == view.centerXAnchor + offsets.dx =&= priority =%= [identifier, "centerY"],
                           centerYAnchor == view.centerYAnchor + offsets.dy =&= priority =%= [identifier, "centerX"]
        )
    }

    @discardableResult public func constrainSizeToSize(of view: OSView? = nil, offsets: CGVector = .zero, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor == view.widthAnchor + offsets.dx =&= priority =%= [identifier, "width"],
                           heightAnchor == view.heightAnchor + offsets.dy =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func constrainWidthToWidth(of view: OSView? = nil, offset: CGFloat = 0, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor == view.widthAnchor + offset =&= priority =%= [identifier, "width"]
        )
    }

    @discardableResult public func constrainHeightToHeight(of view: OSView? = nil, offset: CGFloat = 0, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           heightAnchor == view.heightAnchor + offset =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func constrainWidth(to width: CGFloat, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor == width =&= priority =%= [identifier, "width"]
        )
    }

    @discardableResult public func constrainHeight(to height: CGFloat, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return Constraints(activate: activate, identifier: identifier,
                           heightAnchor == height =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func constrainMinHeight(to height: CGFloat, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return Constraints(activate: activate, identifier: identifier,
                           heightAnchor >= height =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func constrainAspect(to aspect: CGFloat = 1.0, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor == heightAnchor * aspect =&= priority =%= [identifier, "aspect"]
        )
    }

    @discardableResult @nonobjc public func constrainAspect(to aspectSize: CGSize, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return constrainAspect(to: aspectSize.aspect, priority: priority, activate: activate, identifier: identifier)
    }

    @discardableResult @nonobjc public func constrainAspect(to aspectSize: Size, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return constrainAspect(to: CGFloat(aspectSize.aspect), priority: priority, activate: activate, identifier: identifier)
    }

    @discardableResult public func constrainAspect(to aspectRatio: AspectRatio, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return constrainAspect(to: CGFloat(aspectRatio.aspectSize.aspect), priority: priority, activate: activate, identifier: identifier)
    }

    @discardableResult public func constrainSize(to size: CGSize, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor == size.width =&= priority =%= [identifier, "width"],
                           heightAnchor == size.height =&= priority =%= [identifier, "height"]
        )
    }

    @discardableResult public func constrainMaxWidthToWidth(of view: OSView? = nil, inset: CGFloat = 0, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           widthAnchor <= view.widthAnchor - inset =&= priority =%= [identifier, "maxWidth"]
        )
    }

    @discardableResult public func constrainMaxHeightToHeight(of view: OSView? = nil, inset: CGFloat = 0, priority: LayoutPriority = .required, activate: Bool = true, identifier: String? = nil) -> Constraints {
        let view = checkTargetView(view: view)
        return Constraints(activate: activate, identifier: identifier,
                           heightAnchor <= view.heightAnchor - inset =&= priority =%= [identifier, "maxHeight"]
        )
    }

    public func setPriority(hugH: LayoutPriority? = nil, hugV: LayoutPriority? = nil, crH: LayoutPriority? = nil, crV: LayoutPriority? = nil) {
        if let hugH = hugH { setContentHuggingPriority(hugH, for: .horizontal) }
        if let hugV = hugV { setContentHuggingPriority(hugV, for: .vertical) }
        if let crH = crH { setContentCompressionResistancePriority(crH, for: .horizontal) }
        if let crV = crV { setContentCompressionResistancePriority(crV, for: .vertical) }
    }
}

@discardableResult public prefix func ‡<T: OSView> (rhs: T) -> T {
    rhs.translatesAutoresizingMaskIntoConstraints = false
    return rhs
}

// swiftlint:enable cyclomatic_complexity

#if !os(macOS)
    extension NSLayoutConstraint.Axis: CustomStringConvertible {
        public var description: String {
            switch self {
            case .horizontal:
                return ".horizontal"
            case .vertical:
                return ".vertical"
            }
        }
    }
#endif
