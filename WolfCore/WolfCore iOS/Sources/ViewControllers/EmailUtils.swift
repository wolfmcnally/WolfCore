//
//  EmailUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import MessageUI
import WolfBase

public let mailComposer = MailComposer()

public struct MailAttachment {
    public let data: Data
    public let contentType: ContentType
    public let fileName: String

    public init(data: Data, contentType: ContentType, fileName: String) {
        self.data = data
        self.contentType = contentType
        self.fileName = fileName
    }
}

public class MailComposer: NSObject {
    var viewController: MFMailComposeViewController!
    public typealias CompletionBlock = ((MFMailComposeResult) -> Void)
    fileprivate var completion: CompletionBlock?
    
    public func presentComposer(fromViewController presentingViewController: UIViewController, toRecipients recipients: [String], subject: String, body: String? = nil, attachments: [MailAttachment]? = nil, completion: CompletionBlock? = nil) {
        guard !isSimulator else {
            presentingViewController.presentOKAlert(withMessage: "The simulator cannot send e-mail.", identifier: "notEmailCapable")
            return
        }
        
        guard MFMailComposeViewController.canSendMail() else {
            presentingViewController.presentOKAlert(withMessage: "Your device cannot send email."¶, identifier: "notEmailCapable")
            return
        }
        
        guard viewController == nil else {
            logError("There is already a mail composer active.")
            return
        }
        
        viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients(recipients)
        viewController.setSubject(subject)
        viewController.setMessageBody(body ?? "", isHTML: false)

        if let attachments = attachments {
            for attachment in attachments {
                viewController.addAttachmentData(attachment.data, mimeType: attachment.contentType.rawValue, fileName: attachment.fileName)
            }
        }
        
        self.completion = completion
        
        presentingViewController.present(viewController, animated: true, completion: nil)
    }
    
    public func presentComposer(fromViewController presentingViewController: UIViewController, toRecipient recipient: String, subject: String, body: String? = nil, attachments: [MailAttachment]? = nil, completion: CompletionBlock? = nil) {
        
        presentComposer(fromViewController: presentingViewController, toRecipients: [recipient], subject: subject, body: body, attachments: attachments, completion: completion)
    }
}

extension MailComposer : MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        viewController.dismiss() {
            self.completion?(result)
            self.viewController = nil
        }
    }
}
