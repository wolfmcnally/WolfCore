//
//  DeepPressGestureRecognizer.swift
//  WolfCore iOS
//
//  Created by Wolf McNally on 1/12/18.
//  Copyright © 2018 WolfMcNally.com. All rights reserved.
//

//
// Based on:
// https://github.com/FlexMonkey/DeepPressGestureRecognizer/
//

//
//  DeepPressGestureRecognizer.swift
//  DeepPressGestureRecognizer
//
//  Created by SIMON_NON_ADMIN on 03/10/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
//  Thanks to Alaric Cole - bridging header replaced by proper import :)
import AudioToolbox
import UIKit
import UIKit.UIGestureRecognizerSubclass

public let feedbackGenerator = FeedbackGenerator()

public class FeedbackGenerator {
    //available(iOS, 10.0, *)
    private var selectionGenerator: Any?
    private var heavyGenerator: Any?
    private var mediumGenerator: Any?
    private var lightGenerator: Any?
    private var notificationGenerator: Any?

    public func selectionChanged() {
        if #available(iOS 10.0, *) {
            if selectionGenerator == nil {
                selectionGenerator = UISelectionFeedbackGenerator()
            }

            (selectionGenerator as! UISelectionFeedbackGenerator).selectionChanged()
        }
    }

    public func heavy() {
        if #available(iOS 10.0, *) {
            if heavyGenerator == nil {
                heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
            }

            (heavyGenerator as! UIImpactFeedbackGenerator).impactOccurred()
        }
    }

    public func medium() {
        if #available(iOS 10.0, *) {
            if mediumGenerator == nil {
                mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
            }

            (mediumGenerator as! UIImpactFeedbackGenerator).impactOccurred()
        }
    }

    public func light() {
        if #available(iOS 10.0, *) {
            if lightGenerator == nil {
                lightGenerator = UIImpactFeedbackGenerator(style: .light)
            }

            (lightGenerator as! UIImpactFeedbackGenerator).impactOccurred()
        }
    }

    public func error() {
        if #available(iOS 10.0, *) {
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
            }

            (notificationGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.error)
        }
    }

    public func success() {
        if #available(iOS 10.0, *) {
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
            }

            (notificationGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.success)
        }
    }

    public func warning() {
        if #available(iOS 10.0, *) {
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
            }

            (notificationGenerator as! UINotificationFeedbackGenerator).notificationOccurred(.warning)
        }
    }
}

// MARK: GestureRecognizer
public class DeepPressGestureRecognizer: UIGestureRecognizer
{
    public let threshold: CGFloat
    private var deepPressed: Bool = false

    public required init(target: AnyObject? = nil, action: Selector? = nil, threshold: CGFloat = 0.75) {
        self.threshold = threshold
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

        state = deepPressed ? .ended : .failed

        deepPressed = false
    }

    private func handleTouch(_ touch: UITouch) {
        guard let view = view, touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }

        if !deepPressed && (touch.force / touch.maximumPossibleForce) >= threshold {
            state = .began
            feedbackGenerator.heavy()
            deepPressed = true
        } else if deepPressed && (touch.force / touch.maximumPossibleForce) < threshold {
            state = .ended
            deepPressed = false
        }
    }
}
