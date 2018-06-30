//
//  StackViewExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/4/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

extension UIStackView.Distribution: CustomStringConvertible {
    public var description: String {
        switch self {
        case .equalCentering:
            return ".equalCentering"
        case .equalSpacing:
            return ".equalSpacing"
        case .fill:
            return ".fill"
        case .fillEqually:
            return ".fillEqually"
        case .fillProportionally:
            return ".fillProportionally"
        }
    }
}

extension UIStackView.Alignment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .center:
            return ".center"
        case .fill:
            return ".fill"
        case .firstBaseline:
            return ".firstBaseline"
        case .lastBaseline:
            return ".lastBaseline"
        case .leading:
            return ".leading"
        case .trailing:
            return ".trailing"
        }
    }
}
//
//extension UIStackView {
//    public func addArrangedSubviews(_ views: [UIView]) {
//        for view in views {
//            addArrangedSubview(view)
//        }
//    }
//
//    public func addArrangedSubviews(_ views: UIView...) {
//        addArrangedSubviews(views)
//    }
//}
