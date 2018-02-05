//
//  EmailComposer.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import MessageUI

public let emailComposer = EmailComposer()

public struct EmailMessageAttachment {
    public let data: Data
    public let contentType: ContentType
    public let fileName: String

    public init(data: Data, contentType: ContentType, fileName: String) {
        self.data = data
        self.contentType = contentType
        self.fileName = fileName
    }
}

public class EmailComposer: NSObject {
    private typealias `Self` = EmailComposer

    static var viewController: MFMailComposeViewController!
    public typealias CompletionBlock = ((MFMailComposeResult) -> Void)
    fileprivate static var completion: CompletionBlock?

    override init() {
        super.init()
    }

    public static func presentComposer(fromViewController presentingViewController: UIViewController, toRecipients recipients: [String], subject: String, body: String, attachments: [EmailMessageAttachment]? = nil, completion: CompletionBlock? = nil) {
        guard !isSimulator else {
            presentingViewController.presentOKAlert(withMessage: "The simulator cannot send e-mail.", identifier: "notEmailCapable")
            return
        }

        guard MFMailComposeViewController.canSendMail() else {
            presentingViewController.presentOKAlert(withMessage: "Your device is not configured to send email."¶, identifier: "notEmailCapable")
            return
        }

        guard Self.viewController == nil else {
            logError("There is already a mail composer active.")
            return
        }

        viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = emailComposer
        viewController.setToRecipients(recipients)
        viewController.setSubject(subject)
        viewController.setMessageBody(body, isHTML: false)

        for attachment in attachments ?? [] {
            viewController.addAttachmentData(attachment.data, mimeType: attachment.contentType.rawValue, fileName: attachment.fileName)
        }

        self.completion = completion

        presentingViewController.present(viewController, animated: true, completion: nil)
    }
}

extension EmailComposer : MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        Self.viewController.dismiss() {
            Self.completion?(result)
            Self.completion = nil
            Self.viewController = nil
        }
    }
}

