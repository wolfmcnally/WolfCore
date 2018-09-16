//
//  SpacerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/9/17.
//  Copyright © 2017 WolfMcNally.com.
//

import UIKit

public class SpacerView: View {
    public var width: CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public var height: CGFloat {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public override func setup() {
        isUserInteractionEnabled = false
    }

    public init(width: CGFloat = 10, height: CGFloat = 10) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
        setPriority(hugH: .required, hugV: .required, crH: .required, crV: .required)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}
