//
//  FrameView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/4/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class FrameView: View {
    public var color: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public enum Style {
        case none
        case rectangle
        case rounded(cornerRadius: CGFloat) // corner radius
        case underline // uses bottom of first child view as the place to draw the underline
    }
    
    public var style: Style = .rectangle {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var lineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var insetBounds: CGRect {
        let halfLineWidth = lineWidth / 2
        return bounds.insetBy(dx: halfLineWidth, dy: halfLineWidth)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawIntoCurrentContext { context in
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(lineWidth)
            
            switch style {
            case .none:
                break
                
            case .rectangle:
                context.stroke(insetBounds)
                
            case .rounded(let cornerRadius):
                let path = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)
                path.stroke()
                
            case .underline:
                guard let childView = subviews.first else {
                    logWarning("Underline frame with no child view.")
                    return
                }
                
                let childFrame = childView.frame.offsetBy(dx: 0, dy: 4)
                let path = UIBezierPath()
                path.move(to: childFrame.minXmaxY)
                path.addLine(to: childFrame.maxXmaxY)
                path.stroke()
            }
        }
    }
}
