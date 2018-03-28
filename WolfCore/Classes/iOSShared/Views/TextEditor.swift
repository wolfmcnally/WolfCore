//
//  TextEditor.swift
//  WolfCore_iOS
//
//  Created by Wolf McNally on 11/2/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

protocol TextEditor: AnyObject {
    func becomeFirstResponder() -> Bool
    func reloadInputViews()

    var inputView: UIView? { get set }
    var inputAccessoryView: UIView? { get set }
    var plainText: String { get set }
    var textColor: UIColor? { get set }
    var font: UIFont? { get set }
    var textAlignment: NSTextAlignment { get set }

    // UITextInputTraits
    var autocapitalizationType: UITextAutocapitalizationType { get set }
    var autocorrectionType: UITextAutocorrectionType { get set }
    var spellCheckingType: UITextSpellCheckingType { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var enablesReturnKeyAutomatically: Bool { get set }
    var keyboardType: UIKeyboardType { get set }
    var keyboardAppearance: UIKeyboardAppearance { get set }
    var isSecureTextEntry: Bool { get set }

    @available(iOS 10.0, *)
    var textContentType: UITextContentType! { get set }
}

extension TextField: TextEditor { }

extension TextView: TextEditor { }
