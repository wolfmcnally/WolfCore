//
//  FrameView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/4/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class FrameView: View {
    public var strokeColor: UIColor? = .black {
        didSet { setNeedsDisplay() }
    }

    public var fillColor: UIColor? {
        didSet { setNeedsDisplay() }
    }

    public enum Style {
        case none
        case rectangle
        case rounded(cornerRadius: CGFloat) // corner radius
        case underline // uses bottom of first child view as the place to draw the underline
        case custom(view: UIView)
    }

    public override func setup() {
        super.setup()

        contentMode = .redraw
    }

    public var style: Style = .rectangle {
        willSet {
            switch style {
            case .custom(let view):
                view.removeFromSuperview()
            default:
                break
            }
        }

        didSet {
            switch style {
            case .custom(let view):
                insertSubview(‡view, at: 0)
                view.constrainFrameToFrame()
            default:
                break
            }

            setNeedsDisplay()
        }
    }

    public var lineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawIntoCurrentContext { context in
            var doStroke = false
            var effectiveLineWidth: CGFloat = 0
            var effectiveBounds = bounds
            if let strokeColor = strokeColor {
                context.setStrokeColor(strokeColor.cgColor)
                doStroke = true
                effectiveLineWidth = lineWidth
                let halfLineWidth = lineWidth / 2
                effectiveBounds = bounds.insetBy(dx: halfLineWidth, dy: halfLineWidth)
            }
            var doFill = false
            if let fillColor = fillColor {
                context.setFillColor(fillColor.cgColor)
                doFill = true
            }
            context.setLineWidth(effectiveLineWidth)

            switch style {
            case .none:
                break

            case .rectangle:
                if doFill {
                    context.fill(effectiveBounds)
                }
                if doStroke {
                    context.stroke(effectiveBounds)
                }

            case .rounded(let cornerRadius):
                var effectiveCornerRadius = cornerRadius
                if doStroke {
                    effectiveCornerRadius -= effectiveLineWidth
                }
                let path = UIBezierPath(roundedRect: effectiveBounds, cornerRadius: cornerRadius - effectiveLineWidth)
                if doFill {
                    path.fill()
                }
                if doStroke {
                    path.lineWidth = effectiveLineWidth
                    path.stroke()
                }

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
            case .custom:
                break
            }
        }
    }
}
