//
//  InFlightTokenView.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif
import WolfPipe

class InFlightTokenView: View {
    static let viewHeight: CGFloat = 16

    private var idLabel: Label!
    private var nameLabel: Label!
    private var resultLabel: Label!

    var token: InFlightToken! {
        didSet {
            tokenChanged()
        }
    }

    func tokenChanged() {
        syncToToken()
    }

    private func createLabel() -> Label {
        let fontSize: CGFloat = 10

        let label = Label()
        label.textColor = .white
        label.font = OSFont.systemFont(ofSize: fontSize)
        #if !os(macOS)
            label.shadowColor = OSColor(white: 0.0, alpha: 0.5)
            label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        #endif

        return label
    }

    override func setup() {
        super.setup()

        #if !os(macOS)
            isTransparentToTouches = true
        #endif

        osLayer.cornerRadius = type(of: self).viewHeight / 2
        osLayer.borderWidth = 1.0

        idLabel = createLabel()
        idLabel.setPriority(crH: .required)
        self => [
            idLabel
        ]

        Constraints(
            idLabel.leadingAnchor == leadingAnchor + 5,
            idLabel.centerYAnchor == centerYAnchor
        )

        nameLabel = createLabel() |> { (label: Label) -> Label in
            #if !os(macOS)
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.7
                label.baselineAdjustment = .alignCenters
            #endif
            label.allowsDefaultTighteningForTruncation = true
            label.setPriority(crH: .required)
            self => [
                label
            ]

            Constraints(
                label.centerXAnchor == self.centerXAnchor =&= .defaultHigh,
                label.centerYAnchor == self.centerYAnchor
            )

            return label
        }

        resultLabel = createLabel() |> { (label: Label) -> Label in
            label.setPriority(crH: .required)
            self => [
                label
            ]

            Constraints(
                label.trailingAnchor == self.trailingAnchor - 5,
                label.centerYAnchor == self.centerYAnchor
            )

            return label
        }

        Constraints(
            nameLabel.leadingAnchor >= idLabel.trailingAnchor + 5,
            nameLabel.trailingAnchor <= resultLabel.leadingAnchor - 5
        )
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: OSViewNoIntrinsicMetric, height: type(of: self).viewHeight)
    }

    private static let runningColor = OSColor.yellow
    private static let successColor = OSColor.green
    private static let failureColor = OSColor.red
    private static let canceledColor = OSColor.gray

    private func syncToToken() {
        guard let token = token else { return }

        idLabel.text = String(token.id)
        nameLabel.text = token.name
        var resultText: String?
        let color: OSColor
        if let result = token.result {
            if result.isSuccess {
                color = type(of: self).successColor
            } else if result.isCanceled {
                color = type(of: self).canceledColor
            } else {
                color = type(of: self).failureColor
            }
            if let code = result.code {
                resultText = "=\(code)"
            }
        } else {
            color = type(of: self).runningColor
        }

        backgroundColor = color.withAlphaComponent(0.4)
        osLayer.borderColor = color.withAlphaComponent(0.6).cgColor

        resultLabel.text = resultText
    }
}
