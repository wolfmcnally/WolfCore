//
//  PhotoSafeAreaView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class PhotoSafeAreaView: View {
    public static func addToView(view: UIView) -> PhotoSafeAreaView {
        let safeAreaView = PhotoSafeAreaView()
        view => [
            safeAreaView
        ]
        Constraints(
            safeAreaView.centerXAnchor == view.centerXAnchor,
            safeAreaView.centerYAnchor == view.centerYAnchor,
            safeAreaView.widthAnchor == safeAreaView.heightAnchor,
            safeAreaView.widthAnchor == view.widthAnchor =&= .defaultLow,
            safeAreaView.heightAnchor == view.heightAnchor =&= .defaultLow,
            safeAreaView.widthAnchor <= view.widthAnchor,
            safeAreaView.heightAnchor <= view.heightAnchor
        )
        return safeAreaView
    }
    
    public override func setup() {
        super.setup()
        isUserInteractionEnabled = false
    }
}
