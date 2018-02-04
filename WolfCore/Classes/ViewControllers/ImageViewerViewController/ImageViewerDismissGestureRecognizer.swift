//
//  ImageViewerDismissGestureRecognizer.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/22/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

extension LogGroup {
    public static let imageDismissRecognizer = LogGroup("imageDismissRecognizer")
}

/// Implements a UIGestureRecognizer that is compatible with a UIScrollView containing a UIImageView, and detects a gesture similar to a swipe down.
class ImageViewerDismissGestureRecognizer: UIGestureRecognizer {
    let yMinStart: Frac = 0.7
    let yMinEnd: Frac = 0.8
    let xMaxDrift: Frac = 0.2
    let maxElapsedTime: TimeInterval = 0.3
    
    private var beginPoint: CGPoint!
    private var highestPoint: CGPoint!
    private var beginTimestamp: TimeInterval!
    
    override func reset() {
        super.reset()
        beginPoint = nil
        highestPoint = nil
        beginTimestamp = nil
    }
    
    private func yFrac(for point: CGPoint, in view: UIView) -> Frac {
        return Frac(point.y.lerpedToFrac(from: view.bounds.minY .. view.bounds.maxY))
    }
    
    private func xFrac(for point: CGPoint, in view: UIView) -> Frac {
        return Frac(point.x.lerpedToFrac(from: view.bounds.minX .. view.bounds.maxX))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        logTrace("Began", group: .imageDismissRecognizer)
        
        //        logger?.setGroup(.imageViewerDismissRecognizer)
        //        logger?.level = .trace
        
        let view = self.view!
        
        beginPoint = location(in: view)
        highestPoint = beginPoint
        beginTimestamp = touches.first!.timestamp
        
        guard yFrac(for: beginPoint, in: view) <= yMinStart else {
            logTrace("Failed: started too low", group: .imageDismissRecognizer)
            state = .failed
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        let view = self.view!
        
        let currentPoint = location(in: view)
        let currentTimestamp = touches.first!.timestamp
        
        guard currentPoint.y >= highestPoint.y else {
            logTrace("Failed: moved up", group: .imageDismissRecognizer)
            state = .failed
            return
        }
        
        highestPoint = currentPoint
        
        let elapsedTime = currentTimestamp - beginTimestamp
        guard elapsedTime <= maxElapsedTime else {
            logTrace("Failed: too long", group: .imageDismissRecognizer)
            state = .failed
            return
        }
        
        let xBeginFrac = xFrac(for: beginPoint, in: view)
        let xCurrentFrac = xFrac(for: currentPoint, in: view)
        guard abs(xCurrentFrac - xBeginFrac) <= xMaxDrift else {
            logTrace("Failed: too wide", group: .imageDismissRecognizer)
            state = .failed
            return
        }
        
        if yFrac(for: currentPoint, in: view) >= yMinEnd {
            logTrace("Recognized", group: .imageDismissRecognizer)
            state = .recognized
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        logTrace("Failed: touches ended", group: .imageDismissRecognizer)
        state = .failed
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        
        logTrace("Failed: touches cancelled", group: .imageDismissRecognizer)
        state = .failed
    }
}
