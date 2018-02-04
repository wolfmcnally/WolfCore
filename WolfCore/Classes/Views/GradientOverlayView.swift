//
//  GradientOverlayView.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

open class GradientOverlayView: View {
    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    public var gradient: ColorFracGradient! {
        didSet {
            syncColors()
        }
    }
    
    private func syncColors() {
        var colors = [CGColor]()
        var locations = [NSNumber]()
        gradient.colorFracs.forEach {
            colors.append($0.color.cgColor)
            locations.append(NSNumber(value: Double($0.frac)))
        }
        gradientLayer.colors = colors
        gradientLayer.locations = locations
    }
    
    public var startPoint: CGPoint {
        get { return gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }
    
    public var endPoint: CGPoint {
        get { return gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }
    
    open override func setup() {
        super.setup()
        isUserInteractionEnabled = false
    }
}
