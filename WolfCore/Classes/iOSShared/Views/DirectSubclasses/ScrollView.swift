//
//  ScrollView.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/7/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import UIKit

open class ScrollView: UIScrollView {
    @IBInspectable public var isTransparentToTouches: Bool = false

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
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

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isTransparentToTouches {
            return isTransparentToTouch(at: point, with: event)
        } else {
            return super.point(inside: point, with: event)
        }
    }

    open func setup() { }
}

extension UIScrollView {
    public func scrollToBottom(animated: Bool) {
        dispatchOnMain(afterDelay: 0.1) {
            let contentHeight = self.contentSize.height
            let bottomInset = self.contentInset.bottom
            let boundsHeight = self.bounds.height
            let offset = contentHeight + bottomInset - boundsHeight
            //logInfo("scrollToBottom oldOffset: \(self.contentOffset.y), contentHeight: \(contentHeight) + bottomInset: \(bottomInset) - boundsHeight: \(boundsHeight) == offset: \(offset)")
            guard offset > 0 else { return }
            let p = CGPoint(x: 0, y: offset)
            self.setContentOffset(p, animated: animated)
        }
    }
}
