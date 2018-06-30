//
//  DeepPressGestureRecognizer.swift
//  WolfCore iOS
//
//  Created by Wolf McNally on 1/12/18.
//  Copyright © 2018 WolfMcNally.com. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public class DeepPressGestureRecognizer: UIGestureRecognizer {
    public var forceThreshold: Frac = 0.75
    public var timeThreshold: TimeInterval = 0 {
        didSet {
            syncToTimeThreshold()
        }
    }

    private var needsBeginGesture: Asynchronizer?

    enum DeepPressState {
        case notPressing
        case pressingLight
        case pressedHeavy
        case pressedDeep
    }

    private func syncToTimeThreshold() {
        needsBeginGesture = Asynchronizer(delay: timeThreshold) { [unowned self] in
            self.beginGesture()
        }
    }

    private func beginGesture() {
        myState = .pressedDeep
        state = .began
        feedbackGenerator.heavy()
    }

    private func setNeedsBeginGesture() {
        myState = .pressedHeavy
        if let needsBeginGesture = needsBeginGesture {
            feedbackGenerator.light()
            needsBeginGesture.setNeedsSync()
        } else {
            beginGesture()
        }
    }

    private func cancelBeginGesture() {
        myState = .notPressing
        needsBeginGesture?.cancel()
    }

    private var myState: DeepPressState = .notPressing {
        didSet {
            //print(myState)
        }
    }

    public required init(target: AnyObject? = nil, action: Selector? = nil) {
        super.init(target: target, action: action)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        switch myState {
        case .pressedDeep:
            state = .ended
        default:
            state = .failed
        }
        cancelBeginGesture()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)

        state = .ended
        cancelBeginGesture()
    }

    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }

        let force = Frac(touch.force / touch.maximumPossibleForce)
        switch myState {
        case .notPressing:
            myState = .pressingLight
        case .pressingLight:
            if force >= forceThreshold {
                setNeedsBeginGesture()
            }
        case .pressedHeavy:
            break
        case .pressedDeep:
            break
        }
    }
}
