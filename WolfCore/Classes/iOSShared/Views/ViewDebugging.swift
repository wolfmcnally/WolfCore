//
//  ViewDebugging.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com.
//

import UIKit
import WolfStrings

extension UIView {
    public func printViewHierarchy(includingConstraints includeOwnedConstraints: Bool = false, includingConstraintsAffectingHorizontal includeHConstraints: Bool = false, includingConstraintsAffectingVertical includeVConstraints: Bool = false) {
        let aliaser = ObjectAliaser()
        var stack = [(view: UIView, level: Int, indent: String)]()
        stack.append((self, 0, ""))
        let includeConstraints = includeOwnedConstraints || includeHConstraints || includeVConstraints
        repeat {
            let (view, level, indent) = stack.removeLast()

            let prefixJoiner = Joiner()
            let constraintPrefixJoiner = Joiner()

            appendScrollViewPrefix(for: view, prefixJoiner: prefixJoiner, constraintPrefixJoiner: constraintPrefixJoiner)

            prefixJoiner.append(view.translatesAutoresizingMaskIntoConstraints ? "⛔️" : "✅")
            constraintPrefixJoiner.append("⬜️")

            prefixJoiner.append(view.hasAmbiguousLayout ? "❓" : "✅")
            constraintPrefixJoiner.append("⬜️")

            appendFocusedPrefix(for: view, prefixJoiner: prefixJoiner, constraintPrefixJoiner: constraintPrefixJoiner)

            let joiner = Joiner()
            joiner.append(prefixJoiner)

            joiner.append( indent, "\(level)".padded(to: 2) )

            if includeConstraints {
                joiner.append("🔲")
            }

            joiner.append(aliaser.name(for: view))

            joiner.append("frame:\(view.frame.debugSummary)")

            appendAttributes(for: view, to: joiner)

            Swift.print(joiner)

            if includeConstraints {
                var needBlankLines = [Bool]()

                if includeOwnedConstraints {
                    needBlankLines.append(print(constraints: view.constraints, withPrefix: "🔳", currentView: view, constraintPrefixJoiner: constraintPrefixJoiner, indent: indent, aliaser: aliaser))
                }

                if includeHConstraints {
                    needBlankLines.append(print(constraints: view.constraintsAffectingLayout(for: .horizontal), withPrefix: "H:", currentView: view, constraintPrefixJoiner: constraintPrefixJoiner, indent: indent, aliaser: aliaser))
                }

                if includeVConstraints {
                    needBlankLines.append(print(constraints: view.constraintsAffectingLayout(for: .vertical), withPrefix: "V:", currentView: view, constraintPrefixJoiner: constraintPrefixJoiner, indent: indent, aliaser: aliaser))
                }

                if needBlankLines.contains(true) {
                    Swift.print("\(constraintPrefixJoiner.description) \(indent)  │")
                }
            }

            view.subviews.reversed().forEach { subview in
                stack.append((subview, level + 1, indent + "  |"))
            }
        } while !stack.isEmpty
    }

    private func print(constraints: [NSLayoutConstraint], withPrefix prefix: String, currentView view: UIView, constraintPrefixJoiner: Joiner, indent: String, aliaser: ObjectAliaser) -> Bool {
        let needBlankLines = constraints.count > 0
        if needBlankLines {
            Swift.print("\(constraintPrefixJoiner.description) \(indent)  │")
        }
        for constraint in constraints {
            let constraintJoiner = Joiner()
            constraintJoiner.append(constraintPrefixJoiner, indent, " │  \(prefix)")

            appendAttributes(for: constraint, with: view, to: constraintJoiner, aliaser: aliaser)

            Swift.print(constraintJoiner)
        }
        return needBlankLines
    }

    private func appendScrollViewPrefix(for view: UIView, prefixJoiner: Joiner, constraintPrefixJoiner: Joiner) {
        #if !os(tvOS)
            var scrollViewPrefix = "⬜️"
            if let scrollView = view as? UIScrollView {
                scrollViewPrefix = "🔃"
                if scrollView.scrollsToTop {
                    scrollViewPrefix = "🔝"
                }
            }
            prefixJoiner.append(scrollViewPrefix)
            constraintPrefixJoiner.append("⬜️")
        #endif
    }

    private func appendFocusedPrefix(for view: UIView, prefixJoiner: Joiner, constraintPrefixJoiner: Joiner) {
        #if os(tvOS)
            var focusedPrefix = "⬜️"
            if view.canBecomeFocused {
                focusedPrefix = "💙"
            }
            if view.isFocused {
                focusedPrefix = "💚"
            }
            prefixJoiner.append(focusedPrefix)
            constraintPrefixJoiner.append("⬜️")
        #endif
    }

    private func appendAttributes(for view: UIView, to joiner: Joiner) {
        appendDebugAttributes(for: view, to: joiner)
        appendScrollViewAttributes(for: view, to: joiner)
        appendStackViewAttributes(for: view, to: joiner)
        appendColorAttributes(for: view, to: joiner)
        appendTextAttributes(for: view, to: joiner)
        appendInteractionAttributes(for: view, to: joiner)
        appendOpacityAttributes(for: view, to: joiner)
    }

    private func appendDebugAttributes(for view: UIView, to joiner: Joiner) {
        if let debugIdentifier = view.debugIdentifier {
            joiner.append("debugIdentifier: \(debugIdentifier)")
        }
    }

    private func appendScrollViewAttributes(for view: UIView, to joiner: Joiner) {
        guard let scrollView = view as? UIScrollView else { return }
        joiner.append("contentSize:\(scrollView.contentSize.debugSummary)")
        joiner.append("contentOffset:\(scrollView.contentOffset.debugSummary)")
        if scrollView.zoomScale != 1.0 {
            joiner.append("zoomScale:\(scrollView.zoomScale)")
        }
    }

    private func appendStackViewAttributes(for view: UIView, to joiner: Joiner) {
        guard let stackView = view as? UIStackView else { return }
        joiner.append("axis:\(stackView.axis)")
        joiner.append("distribution:\(stackView.distribution)")
        joiner.append("alignment:\(stackView.alignment)")
        joiner.append("spacing:\(stackView.spacing)")
    }

    private func appendColorAttributes(for view: UIView, to joiner: Joiner) {
        if let backgroundColor = view.backgroundColor {
            if backgroundColor != .clear {
                joiner.append("backgroundColor:\(backgroundColor.debugSummary)")
            }
        }

        if view == self || (view.superview != nil && view.tintColor != view.superview!.tintColor) {
            joiner.append("tintColor:\((view.tintColor ?? defaultTintColor).debugSummary)")
        }
    }

    private func appendTextAttributes(for view: UIView, to joiner: Joiner) {
        if let label = view as? UILabel {
            joiner.append("textColor:\(label.textColor.debugSummary)")
            if let text = label.text {
                joiner.append("text:\"\(text.debugSummary)\"")
            }
        } else if let textView = view as? UITextView {
            if let textColor = textView.textColor {
                joiner.append("textColor:\(textColor.debugSummary)")
            }
            if let text = textView.text {
                joiner.append("text:\"\(text.debugSummary)\"")
            }
        }
    }

    private func appendInteractionAttributes(for view: UIView, to joiner: Joiner) {
        let userInteractionEnabledDefault: Bool
        if view is UILabel || view is UIImageView {
            userInteractionEnabledDefault = false
        } else {
            userInteractionEnabledDefault = true
        }

        if view.isUserInteractionEnabled != userInteractionEnabledDefault {
            joiner.append("isUserInteractionEnabled:\(view.isUserInteractionEnabled)")
        }
    }

    private func appendOpacityAttributes(for view: UIView, to joiner: Joiner) {
        if !(view is UIStackView) {
            if view.isOpaque {
                joiner.append("isOpaque:\(view.isOpaque)")
            }
        }

        if view.alpha < 1.0 {
            joiner.append("alpha:\(view.alpha)")
        }

        if view.isHidden {
            joiner.append("isHidden:\(view.isHidden)")
        }
    }

    private func descriptor(for relationship: ViewRelationship, aliaser: ObjectAliaser) -> String {
        switch relationship {
        case .unrelated:
            return "❌"
        case .same:
            return "✅"
        case .sibling:
            return "⚫️"
        case .ancestor:
            return "🚺"
        case .descendant:
            return "🚼"
        case .cousin(let commonAncestor):
            return "🚹 \(aliaser.name(for: commonAncestor))"
        }
    }

    private func appendDescriptor(for relationship: ViewRelationship, to joiner: Joiner, aliaser: ObjectAliaser) {
        switch relationship {
        case .same:
            break
        default:
            joiner.append(descriptor(for: relationship, aliaser: aliaser))
        }
    }

    private func name(for view: AnyObject, forRelationshipToCurrentView relationship: ViewRelationship, aliaser: ObjectAliaser) -> String {
        var viewName = ""
        switch relationship {
        case .same:
            break
        default:
            viewName = aliaser.name(for: view)
        }
        return viewName
    }

    private func appendAttributes(for constraint: NSLayoutConstraint, with currentView: UIView, to constraintJoiner: Joiner, aliaser: ObjectAliaser) {
        constraintJoiner.append("\(aliaser.name(for: constraint)):")

        let firstItem = constraint.firstItem
        let firstToCurrentRelationship: ViewRelationship
        if let firstView = firstItem as? UIView {
            firstToCurrentRelationship = firstView.relationship(toView: currentView)
        } else {
            firstToCurrentRelationship = .unrelated
        }

        let firstViewName = name(for: firstItem!, forRelationshipToCurrentView: firstToCurrentRelationship, aliaser: aliaser)

        constraintJoiner.append("\(firstViewName).\(string(forAttribute: constraint.firstAttribute))")

        appendDescriptor(for: firstToCurrentRelationship, to: constraintJoiner, aliaser: aliaser)

        constraintJoiner.append(string(forRelation: constraint.relation))

        guard let secondItem = constraint.secondItem else {
            constraintJoiner.append(constraint.constant)
            return
        }

        let secondToCurrentRelationship: ViewRelationship
        if let secondView = secondItem as? UIView {
            secondToCurrentRelationship = secondView.relationship(toView: currentView)
        } else {
            secondToCurrentRelationship = .unrelated
        }

        let secondItemName = name(for: secondItem, forRelationshipToCurrentView: secondToCurrentRelationship, aliaser: aliaser)

        constraintJoiner.append("\(secondItemName).\(string(forAttribute: constraint.secondAttribute))")

        appendDescriptor(for: secondToCurrentRelationship, to: constraintJoiner, aliaser: aliaser)

        if constraint.multiplier != 1.0 {
            constraintJoiner.append("×", constraint.multiplier)
        }
        if constraint.constant > 0.0 {
            constraintJoiner.append("+", constraint.constant)
        } else if constraint.constant < 0.0 {
            constraintJoiner.append("-", -constraint.constant)
        }
        if constraint.priority < LayoutPriority.required {
            constraintJoiner.append("priority:\(constraint.priority)")
        }
    }
}

public func printWindowViewHierarchy(includingConstraints includeConstraints: Bool = false, includingConstraintsAffectingHorizontal includeHConstraints: Bool = false, includingConstraintsAffectingVertical includeVConstraints: Bool = false) {
    UIApplication.shared.windows[0].printViewHierarchy(includingConstraints: includeConstraints, includingConstraintsAffectingHorizontal: includeHConstraints, includingConstraintsAffectingVertical: includeVConstraints)
}
