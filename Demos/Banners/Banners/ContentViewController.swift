//
//  ContentViewController.swift
//  Banners
//
//  Created by Wolf McNally on 6/5/17.
//  Copyright © 2017 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore
import WolfBase

class ContentViewController: ViewController {
    public var isDark: Bool = false {
        didSet {
            syncToDark()
        }
    }

    static func instantiate() -> ContentViewController {
        return ContentViewController()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    private lazy var placeholderView: PlaceholderView = {
        let view = PlaceholderView(title: "Tap for More Banners")
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view => [
            placeholderView
        ]
        placeholderView.constrainFrameToFrame()
    }

    private func syncToDark() {
        if isDark {
            skin = darkSkin
        } else {
            skin = lightSkin
        }
    }
}
