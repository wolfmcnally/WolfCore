//
//  TextMessageComposer.swift
//  WolfCore iOS
//
//  Created by Wolf McNally on 1/30/18.
//  Copyright © 2018 WolfMcNally.com. All rights reserved.
//

import MessageUI

public let textMessageComposer = TextMessageComposer()

public struct TextMessageAttachment {
    public let data: Data
    public let contentType: UniformTypeIdentifier
    public let fileName: String

    public init(data: Data, contentType: UniformTypeIdentifier, fileName: String) {
        self.data = data
        self.contentType = contentType
        self.fileName = fileName
    }
}

public class TextMessageComposer: NSObject {
    private typealias `Self` = TextMessageComposer

    static var viewController: MFMessageComposeViewController!
    public typealias CompletionBlock = ((MessageComposeResult) -> Void)
    fileprivate static var completion: CompletionBlock?

    override init() {
        super.init()
    }

    public static func presentComposer(fromViewController presentingViewController: UIViewController, recipients: [String], body: String, attachments: [TextMessageAttachment]? = nil, completion: CompletionBlock? = nil) {
        guard !isSimulator else {
            presentingViewController.presentOKAlert(withMessage: "The simulator cannot send text messages.", identifier: "notTextMessageCapable")
            return
        }

        guard MFMessageComposeViewController.canSendText() else {
            presentingViewController.presentOKAlert(withMessage: "Your device is not configured to send text messages."¶, identifier: "notTextMessageCapable")
            return
        }

        guard Self.viewController == nil else {
            logError("There is already a text message composer active.")
            return
        }

        viewController = MFMessageComposeViewController()
        viewController.messageComposeDelegate = textMessageComposer
        viewController.recipients = recipients
        viewController.body = body

        for attachment in attachments ?? [] {
            viewController.addAttachmentData(attachment.data, typeIdentifier: attachment.contentType.rawValue, filename: attachment.fileName)
        }

        self.completion = completion

        presentingViewController.present(viewController, animated: true, completion: nil)
    }
}

extension TextMessageComposer : MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        Self.viewController.dismiss() {
            Self.completion?(result)
            Self.completion = nil
            Self.viewController = nil
        }
    }
}

