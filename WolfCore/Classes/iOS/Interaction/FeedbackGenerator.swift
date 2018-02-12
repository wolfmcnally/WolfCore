//
//  FeedbackGenerator.swift
//  CommonCryptoModule
//
//  Created by Wolf McNally on 2/11/18.
//

import AudioToolbox

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
