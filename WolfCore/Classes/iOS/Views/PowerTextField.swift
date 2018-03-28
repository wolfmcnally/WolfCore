//
//  PowerTextField.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/12/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

//public class PlaceholderMessageLabel: Label { }
//public class PlaceholderLabel: Label { }

public class PowerTextField: View, Editable {
    public let name: String
    public let contentType: ContentType
    public let numberOfLines: Int

    public enum ContentType {
        case text           // Generic prose
        case rawText        // Text with no correction or capitalization
        case name           // A person's name
        case email          // An e-mail address
        case phone          // A phone number
        case phoneOrEmail   // A phone number or email address (Apple ID), for text messaging
        case integer(CountableClosedRange<Int>) // An integer in the specified range
        case social         // A social-media handle
        case date           // A date
        case password       // A password (numberOfLines must be 1)
    }

    public init(name: String, contentType: ContentType = .text, numberOfLines: Int = 1) {
        self.name = name
        self.contentType = contentType
        self.numberOfLines = numberOfLines
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public private(set) var isEditing: Bool = false

    public func setEditing(_ isEditing: Bool, animated: Bool) {
        guard self.isEditing != isEditing else { return }
        self.isEditing = isEditing
        if isEditing {
            _ = textEditor.becomeFirstResponder()
        }
        syncToEditing(animated: animated)
    }

    public var textAlignment: NSTextAlignment = .natural {
        didSet {
            syncToAlignment()
        }
    }

    public override var inputView: UIView? {
        get {
            return textEditor.inputView
        }

        set {
            textEditor.inputView = newValue
        }
    }

    public var datePickerChangedAction: ControlAction<UIDatePicker>!

    public var datePicker: UIDatePicker! {
        didSet {
            inputView = datePicker
            datePickerChangedAction = addValueChangedAction(to: datePicker) { [unowned self] _ in
                self.syncTextToDate(animated: true)
            }
        }
    }

    private func syncTextToDate(animated: Bool) {
        let align = textAlignment
        if let date = date {
            setText(dateFormatter.string(from: date), animated: animated)
        } else {
            clear(animated: animated)
        }
        textAlignment = align
    }

    public var date: Date? {
        get {
            return datePicker?.date
        }

        set {
            if let date = newValue {
                datePicker.date = date
            }
        }
    }

    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()

    public var validator: Validator?
    private var remoteValidationActivity: LockerCause?
    private var currentRemoteValidation: SuccessPromise? {
        didSet {
            if currentRemoteValidation == nil {
                remoteValidationActivity = nil
            } else {
                remoteValidationActivity = activityIndicatorView.newActivity()
            }
        }
    }

    public var text: String {
        get {
            return textEditor.plainText
        }

        set {
            _setText(newValue, animated: false)
        }
    }

    private func _setText(_ text: String, animated: Bool) {
        textEditor.plainText = text
        syncToTextEditor(animated: animated)
    }

    private func setText(_ text: String, animated: Bool) {
        guard textEditor.plainText != text else { return }
        _setText(text, animated: animated)
        setNeedsOnTextChanged()
    }

    private lazy var syncOnTextChanged: Asynchronizer = .init(name: "onChanged", delay: 0.1) {
        self.onChanged?(self)
    }

    private func setNeedsOnTextChanged() {
        syncOnTextChanged.setNeedsSync()
    }

    public var keyboardType: UIKeyboardType {
        get { return textEditor.keyboardType }
        set { textEditor.keyboardType = newValue }
    }

    public var placeholder: String? {
        get {
            return placeholderLabel.text
        }

        set {
            placeholderLabel.text = newValue
            placeholderMessageLabel.text = newValue
        }
    }

    public var icon: UIImage? {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var characterLimit: Int? {
        didSet {
            updateCharacterCount()
        }
    }

    public var characterCount: Int {
        return text.count
    }

    public var isEmpty: Bool {
        return characterCount == 0
    }

    public var charactersLeft: Int? {
        guard let characterLimit = characterLimit else { return nil }
        return characterLimit - characterCount
    }

    public var showsCharacterCount: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var showsValidationMessage: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var showsPlaceholderMessage: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var characterCountTemplate = "#{characterCount}/#{characterLimit}"

    private var characterCountString: String {
        return characterCountTemplate ¶ ["characterCount": String(characterCount), "characterLimit": characterLimit†, "charactersLeft": charactersLeft†]
    }

    private func syncToShowsMessage() {
        if showsValidationMessage || showsPlaceholderMessage {
            messageContainerView.show()
            validationMessageLabel.isShown = showsValidationMessage
            placeholderMessageLabel.isShown = showsPlaceholderMessage
        } else {
            messageContainerView.hide()
        }
    }

    private func syncToShowsCharacterCount() {
        switch showsCharacterCount {
        case false:
            characterCountLabel.hide()
        case true:
            characterCountLabel.show()
        }
    }

    fileprivate func updateCharacterCount() {
        characterCountLabel.text = characterCountString
    }

    public private(set) var validatedText: String?

    public private(set) var validationError: ValidationError? {
        didSet {
            if let validationError = validationError {
                validationMessage = .failure(validationError.message)
            } else {
                validationMessage = nil
            }
        }
    }

    private enum ValidationMessage {
        case failure(String)
        case success(String)
    }

    private var validationMessage: ValidationMessage? {
        willSet {
            if validationMessage != nil && newValue == nil {
                concealValidationMessage(animated: true)
            }
        }

        didSet {
            if let validationMessage = validationMessage {
                switch validationMessage {
                case .failure(let message):
                    validationMessageLabel.text = message
                case .success(let message):
                    validationMessageLabel.text = message
                }
                if oldValue == nil {
                    revealValidationMessage(animated: true)
                }
            }
        }
    }

    private func revealValidationMessage(animated: Bool) {
        dispatchAnimated(animated, delay: 0.1, options: .beginFromCurrentState) {
            self.validationMessageLabel.alpha = 1
            self.placeholderMessageContainer.alpha = 0
            }.run()
    }

    private func concealValidationMessage(animated: Bool) {
        dispatchAnimated(animated, delay: 0.1, options: .beginFromCurrentState) {
            self.validationMessageLabel.alpha = 0
            self.placeholderMessageContainer.alpha = 1
            }.run()
    }

    private func revealPlaceholderMessage(animated: Bool) {
        guard validationMessageLabel.alpha == 0 else { return }
        dispatchAnimated(animated, delay: 0.1, options: .beginFromCurrentState) {
            self.placeholderMessageContainer.alpha = 1
            }.run()
    }

    private func concealPlaceholderMessage(animated: Bool) {
        dispatchAnimated(animated, delay: 0.1, options: .beginFromCurrentState) {
            self.placeholderMessageContainer.alpha = 0
            }.run()
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        get { return textEditor.keyboardAppearance }
        set { textEditor.keyboardAppearance = newValue }
    }

    public var disallowedCharacters: CharacterSet? = CharacterSet.controlCharacters
    public var allowedCharacters: CharacterSet?

    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textEditor.autocapitalizationType }
        set { textEditor.autocapitalizationType = newValue }
    }

    public var spellCheckingType: UITextSpellCheckingType {
        get { return textEditor.spellCheckingType }
        set { textEditor.spellCheckingType = newValue }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get { return textEditor.autocorrectionType }
        set { textEditor.autocorrectionType = newValue }
    }

    public var returnKeyType: UIReturnKeyType {
        get { return textEditor.returnKeyType }
        set { textEditor.returnKeyType = newValue }
    }

    public var enablesReturnKeyAutomatically: Bool {
        get { return textEditor.enablesReturnKeyAutomatically }
        set { textEditor.enablesReturnKeyAutomatically = newValue }
    }

    public private(set) var isSecureTextEntry: Bool {
        get { return textEditor.isSecureTextEntry }
        set {
            textEditor.isSecureTextEntry = newValue
            syncToSecureTextEntry()
        }
    }

    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        get { return textEditor.textContentType }
        set { textEditor.textContentType = newValue }
    }

    public enum ClearButtonMode {
        case never
        case whileEditing
        case unlessEditing
        case always
    }

    public var clearButtonMode: ClearButtonMode = .whileEditing {
        didSet {
            syncClearButton(animated: false)
        }
    }

    private func syncClearButton(animated: Bool) {
        switch clearButtonMode {
        case .never:
            clearButtonView.conceal(animated: animated)
        case .whileEditing:
            if isEditing && !isEmpty {
                clearButtonView.reveal(animated: animated)
            } else {
                clearButtonView.conceal(animated: animated)
            }
        case .unlessEditing:
            if isEditing {
                clearButtonView.conceal(animated: animated)
            } else {
                clearButtonView.reveal(animated: animated)
            }
        case .always:
            clearButtonView.reveal(animated: animated)
        }
    }

    public typealias ResponseBlock = (PowerTextField) -> Void
    public var onBeginEditing: ResponseBlock?
    public var onEndEditing: ResponseBlock?
    public var onChanged: ResponseBlock?

    @objc dynamic public var verticalSpacing: CGFloat {
        get { return verticalStackView.spacing }
        set { verticalStackView.spacing = newValue }
    }

    private lazy var verticalStackView: VerticalStackView = .init() • { 🍒 in
        🍒.alignment = .leading
    }

    private lazy var topRowView: HorizontalStackView = .init() • { 🍒 in
        🍒.alignment = .center
    }

    private lazy var placeholderMessageContainer: HorizontalStackView = .init() • { 🍒 in
        🍒.alignment = .center
        🍒.spacing = 10
        🍒.alpha = 0
    }

    private lazy var bottomRowView: HorizontalStackView = .init() • { 🍒 in
        🍒.alignment = .center
    }

    @objc dynamic public var frameColor: UIColor {
        get { return frameView.strokeColor ?? .clear }
        set { frameView.strokeColor = newValue }
    }

    @objc dynamic public var frameCornerRadius: CGFloat {
        get {
            switch frameStyle {
            case .rounded(let cornerRadius):
                return cornerRadius
            default:
                return 0
            }
        }

        set { frameStyle = .rounded(cornerRadius: newValue) }
    }

    public var frameStyle: FrameView.Style {
        get { return frameView.style }

        set {
            frameView.style = newValue
            syncToFrameMode()
        }
    }

    @objc dynamic public var frameLineWidth: CGFloat {
        get { return frameView.lineWidth }
        set { frameView.lineWidth = newValue }
    }

    private lazy var frameView: FrameView = .init()

    @objc dynamic public var horizontalSpacing: CGFloat = 6 {
        didSet {
            horizontalStackView.spacing = horizontalSpacing
        }
    }

    private lazy var horizontalStackView: HorizontalStackView = .init() • { 🍒 in
        🍒.spacing = self.horizontalSpacing
        🍒.alignment = .center
    }

    private lazy var characterCountLabel: Label = .init()

    private lazy var messageSpacerView: SpacerView = .init() • { 🍒 in
        🍒.setPriority(hugH: .defaultHigh, crH: .required)
    }

    @objc dynamic public var validationMessageTextColor: UIColor? {
        get { return validationMessageLabel.textColor }
        set { validationMessageLabel.textColor = newValue }
    }

    @objc dynamic public var validationMessageFont: UIFont? {
        get { return validationMessageLabel.font }
        set { validationMessageLabel.font = newValue }
    }

    private lazy var validationMessageLabel: Label = .init() • { 🍒 in
        🍒.setPriority(hugH: .required, crH: .required)
        🍒.adjustsFontSizeToFitWidth = true
        🍒.minimumScaleFactor = 0.5
        🍒.text = "A"
        🍒.alpha = 0
    }

    @objc dynamic public var placeholderMessageTextColor: UIColor? {
        get { return placeholderMessageLabel.textColor }
        set { placeholderMessageLabel.textColor = newValue }
    }

    @objc dynamic public var placeholderMessageFont: UIFont? {
        get { return placeholderMessageLabel.font }
        set { placeholderMessageLabel.font = newValue }
    }

    private lazy var placeholderMessageLabel: Label = .init() • { 🍒 in
        🍒.setPriority(hugH: .required, crH: .required)
        🍒.adjustsFontSizeToFitWidth = true
        🍒.minimumScaleFactor = 0.5
        🍒.text = "A"
    }

    private lazy var messageContainerView: View = .init() • { 🍒 in
        🍒.setPriority(hugH: .required, crH: .required)
    }

    @objc dynamic public var placeholderTextColor: UIColor? {
        get { return placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }

    @objc dynamic public var placeholderFont: UIFont? {
        get { return placeholderLabel.font }
        set { placeholderLabel.font = newValue }
    }

    private lazy var placeholderLabel: Label = .init() • { 🍒 in
        if self.numberOfLines > 1 {
            🍒.numberOfLines = 0
        } else {
            🍒.adjustsFontSizeToFitWidth = true
            🍒.minimumScaleFactor = 0.5
        }
    }

    private lazy var textEditorView: UIView = {
        let needsTextField: Bool
        switch self.contentType {
        case .password:
            needsTextField = true
        default:
            needsTextField = false
        }
        let needsTextView = self.numberOfLines > 1
        assert(!needsTextField || !needsTextView)
        return needsTextView ? self.textView : self.textField
    }()

    @objc dynamic public var textColor: UIColor? {
        get { return textEditor.textColor }
        set { textEditor.textColor = newValue }
    }

    @objc dynamic public var font: UIFont? {
        get { return textEditor.font }
        set { textEditor.font = newValue }
    }

    private var textEditor: TextEditor {
        return textEditorView as! TextEditor
    }

    private var textChangedAction: ControlAction<TextField>!

    private lazy var textField: TextField = .init() • { 🍒 in
        self.textChangedAction = addControlAction(to: 🍒, for: .editingChanged) { [unowned self] _ in
            self.syncToTextEditor(animated: true)
        }
        🍒.delegate = self
    }

    private lazy var textView: TextView = .init() • { 🍒 in
        🍒.contentInset = .zero
        🍒.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: -4)
        🍒.scrollsToTop = false
        🍒.delegate = self
    }

    private lazy var iconView: ImageView = .init() • { 🍒 in
        🍒.setPriority(hugH: .required)
    }

    private var onClearAction: ControlAction<Button>!

    private lazy var clearButtonView: ClearFieldButtonView = .init() • { 🍒 in
        self.onClearAction = addTouchUpInsideAction(to: 🍒.button) { [unowned self] _ in
            self.clear(animated: true)
        }
    }

    public var showsToggleSecureTextEntryButton = false {
        didSet {
            syncToSecureTextEntry()
        }
    }

    private var onToggleSecureTextEntryAction: ControlAction<Button>!

    private lazy var toggleSecureTextEntryButton: Button = .init() • { 🍒 in
        🍒.setPriority(hugH: .required, hugV: .required)
        self.onToggleSecureTextEntryAction = addTouchUpInsideAction(to: 🍒) { [unowned self] _ in
            self.toggleSecureTextEntry()
        }
    }

    private func toggleSecureTextEntry() {
        isSecureTextEntry = !isSecureTextEntry
    }

    private func syncToSecureTextEntry() {
        switch contentType {
        case .password where showsToggleSecureTextEntryButton:
            toggleSecureTextEntryButton.show()
            let title = isSecureTextEntry ? "Show"¶ : "Hide"¶
            toggleSecureTextEntryButton.setTitle(title, for: .normal)
        default:
            toggleSecureTextEntryButton.hide()
        }
    }

    public func clear(animated: Bool) {
        setText("", animated: animated)
        removeValidation()
        setNeedsValidation()
//        needsValidation = true
    }

    private lazy var activityIndicatorView: ActivityIndicatorView = .init() • { 🍒 in
        🍒.setPriority(crH: .required)
    }

//    public override var isDebug: Bool {
//        didSet {
//            frameView.isDebug = isDebug
//            characterCountLabel.isDebug = isDebug
//            validationMessageLabel.isDebug = isDebug
//            placeholderMessageLabel.isDebug = isDebug
//            placeholderMessageContainer.isDebug = isDebug
//            textEditor.isDebug = isDebug
//            iconView.isDebug = isDebug
//            clearButtonView.isDebug = isDebug
//            toggleSecureTextEntryButton.isDebug = isDebug
//            activityIndicatorView.isDebug = isDebug
//
//            debugBackgroundColor = .green
//            frameView.debugBackgroundColor = .blue
//            characterCountLabel.debugBackgroundColor = .gray
//            validationMessageLabel.debugBackgroundColor = .red
//            placeholderMessageLabel.debugBackgroundColor = .blue
//            placeholderMessageContainer.debugBackgroundColor = .blue
//            textEditor.debugBackgroundColor = .green
//            iconView.debugBackgroundColor = .blue
//            clearButtonView.debugBackgroundColor = .blue
//            toggleSecureTextEntryButton.debugBackgroundColor = .blue
//            activityIndicatorView.debugBackgroundColor = .blue
//        }
//    }

    private var frameInsets = CGInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            syncToFrameInsets()
        }
    }

    private var frameContentConstraints = Constraints()
    private func syncToFrameInsets() {
        frameContentConstraints ◊= horizontalStackView.constrainFrameToFrame(insets: frameInsets)
    }

    public var rectangleFrameInsets = CGInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            frameInsets = rectangleFrameInsets
            syncToFrameInsets()
        }
    }

    public var underlineFrameInsets = CGInsets(top: 2, left: 0, bottom: 6, right: 0) {
        didSet {
            frameInsets = underlineFrameInsets
            syncToFrameInsets()
        }
    }

    private func syncToFrameMode() {
        switch frameStyle {
        case .rectangle, .rounded, .none, .custom:
            frameInsets = rectangleFrameInsets
        case .underline:
            frameInsets = underlineFrameInsets
        }
        messageSpacerView.width = frameInsets.left!
    }

    public var topRightViews = [UIView]() {
        didSet {
            topRightItemsView.removeAllSubviews()
            topRightItemsView => topRightViews
        }
    }

    private lazy var topRightItemsView: HorizontalStackView = .init() • { 🍒 in
        🍒.spacing = 5
    }

    public override func setup() {
        super.setup()

        syncToContentType()
        self => [
            verticalStackView => [
                topRowView => [
                    messageSpacerView,
                    messageContainerView => [
                        validationMessageLabel,
                        placeholderMessageContainer => [
                            placeholderMessageLabel,
                            activityIndicatorView
                        ]
                    ],
                    SpacerView() • {
                        $0.width = noSize
                        $0.setPriority(crH: .defaultLow)
                    },
                    topRightItemsView
                ],
                frameView => [
                    horizontalStackView => [
                        iconView,
                        textEditorView,
                        clearButtonView,
                        toggleSecureTextEntryButton
                    ]
                ],
                bottomRowView => [
                    characterCountLabel
                ]
            ],
            placeholderLabel
        ]

        Constraints(frameView.widthAnchor == verticalStackView.widthAnchor)
        verticalStackView.constrainFrameToFrame()
        syncToFrameInsets()
        syncToSecureTextEntry()
        textViewHeightConstraint = textEditorView.constrainHeight(to: 20)
        Constraints(
            placeholderLabel.leadingAnchor == textEditorView.leadingAnchor,
            placeholderLabel.trailingAnchor == textEditorView.trailingAnchor,
            placeholderLabel.topAnchor == textEditorView.topAnchor
        )

        Constraints(
            textEditorView.heightAnchor >= clearButtonView.heightAnchor,
            toggleSecureTextEntryButton.heightAnchor == clearButtonView.heightAnchor
        )

        Constraints(
            //messageContainerView.widthAnchor == topRowView.widthAnchor,
            topRowView.widthAnchor == verticalStackView.widthAnchor
        )

        Constraints(
            messageContainerView.topAnchor == validationMessageLabel.topAnchor,
            messageContainerView.bottomAnchor == validationMessageLabel.bottomAnchor,
            messageContainerView.leadingAnchor == validationMessageLabel.leadingAnchor,
            messageContainerView.widthAnchor == validationMessageLabel.widthAnchor =&= .defaultLow,
            messageContainerView.widthAnchor >= validationMessageLabel.widthAnchor,

            messageContainerView.topAnchor == placeholderMessageContainer.topAnchor,
            messageContainerView.bottomAnchor == placeholderMessageContainer.bottomAnchor,
            messageContainerView.leadingAnchor == placeholderMessageContainer.leadingAnchor,
            messageContainerView.widthAnchor == placeholderMessageContainer.widthAnchor =&= .defaultLow,
            messageContainerView.widthAnchor >= placeholderMessageContainer.widthAnchor
        )

        syncClearButton(animated: false)
        //isDebug = true
    }

    private var textViewHeightConstraint: Constraints!

    private var lineHeight: CGFloat {
        return textEditor.font?.lineHeight ?? 20
    }

    public override func updateConstraints() {
        super.updateConstraints()

        syncToIcon()
        syncToShowsMessage()
        syncToShowsCharacterCount()
        syncToFont()
    }

    private func syncToIcon() {
        if let icon = icon {
            iconView.image = icon
            iconView.show()
        } else {
            iconView.hide()
        }
    }

    private func syncToFont() {
        textViewHeightConstraint.constraints.first!.constant = ceil(lineHeight * CGFloat(numberOfLines))
    }

    private func concealPlaceholder(animated: Bool) {
        dispatchAnimated(animated) {
            self.placeholderLabel.alpha = 0
            }.run()
    }

    private func revealPlaceholder(animated: Bool) {
        dispatchAnimated(animated) {
            self.placeholderLabel.alpha = 1
            }.run()
    }

    fileprivate lazy var placeholderHider: Locker = {
        return Locker(
            onLocked: { [unowned self] in
                self.concealPlaceholder(animated: true)
                self.revealPlaceholderMessage(animated: true)
            }, onUnlocked: { [weak self] in
                self?.revealPlaceholder(animated: true)
                self?.concealPlaceholderMessage(animated: true)
        })
    }()

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        keyboardSwitchView?.tintColor = tintColor
    }

    private var keyboardSwitchView: SegmentedAccessoryInputView!

    private func syncToContentType() {
        func setEmailKeyboard() {
            keyboardType = .emailAddress
            autocapitalizationType = .none
            spellCheckingType = .no
            autocorrectionType = .no
        }

        func setPhoneKeyboard() {
            keyboardType = .numberPad
        }

        switch contentType {
        case .text:
            break
        case .integer(let validRange):
            keyboardType = .decimalPad
            validator = IntValidator(name: name, validRange: validRange)
        case .name:
            autocapitalizationType = .words
            spellCheckingType = .no
            autocorrectionType = .no
        case .rawText, .social:
            autocapitalizationType = .none
            spellCheckingType = .no
            autocorrectionType = .no
        case .email:
            setEmailKeyboard()
        case .phone:
            setPhoneKeyboard()
        case .phoneOrEmail:
            keyboardSwitchView = SegmentedAccessoryInputView()
            keyboardSwitchView.tintColor = tintColor
            keyboardSwitchView.addSegment(title: "Phone Number") { [unowned self] in
                setPhoneKeyboard()
                self.textEditor.reloadInputViews()
            }
            keyboardSwitchView.addSegment(title: "Apple ID (Email)") { [unowned self] in
                setEmailKeyboard()
                self.textEditor.reloadInputViews()
            }
            textEditor.inputAccessoryView = keyboardSwitchView
        case .date:
            datePicker = UIDatePicker()
        case .password:
            isSecureTextEntry = true
            autocapitalizationType = .none
            spellCheckingType = .no
            autocorrectionType = .no
        }
    }

    private lazy var keyboardNotificationActions = KeyboardNotificationActions()

    fileprivate var scrollToVisibleWhenKeyboardShows = false {
        didSet {
            if scrollToVisibleWhenKeyboardShows {
                keyboardNotificationActions.didShow = { [unowned self] _ in
                    self.scrollEditorToVisible()
                }
            } else {
                keyboardNotificationActions.didShow = nil
            }
        }
    }

    private func scrollContentToTop() {
        (textEditorView as? TextView)?.setContentOffset(.zero, animated: true)
    }

    private func scrollEditorToVisible() {
        func doScroll() {
            for ancestor in allAncestors() {
                if let scrollView = ancestor as? UIScrollView {
                    let rect = convert(bounds, to: scrollView).insetBy(dx: -8, dy: -8)
                    scrollView.scrollRectToVisible(rect, animated: true)
                    break
                }
            }
        }

        dispatchOnMain(afterDelay: 0.05) {
            doScroll()
        }
    }

    fileprivate func syncToAlignment() {
        textEditor.textAlignment = textAlignment
        placeholderLabel.textAlignment = textAlignment
    }

    fileprivate func syncToTextEditor(animated: Bool) {
        syncClearButton(animated: animated)
        updateCharacterCount()
        placeholderHider["editing"] = isEditing
        placeholderHider["hasText"] = !isEmpty
        scrollToVisibleWhenKeyboardShows = isEditing
        syncToAlignment()
    }

    public func syncToEditing(animated: Bool) {
        if isEditing {
            scrollEditorToVisible()
            removeValidation()
            onBeginEditing?(self)
        } else {
            scrollContentToTop()
            if !hasValidation {
                validate()
            }
            onEndEditing?(self)
        }
        syncToTextEditor(animated: animated)
    }

    private var validationTimer: Cancelable?
    private func restartValidationTimer() {
        guard validator != nil else { return }
        cancelValidationTimer()
        validationTimer = dispatchOnMain(afterDelay: 1.0) {
            self.validateIfNeeded()
        }
    }

    private func removeValidation() {
        validationError = nil
    }

    private var hasValidation: Bool {
        return validationMessage != nil
    }

    private func cancelValidationTimer() {
        validationTimer?.cancel()
        validationTimer = nil
        removeValidation()
    }

    private var needsValidation = true {
        didSet {
            //print("needsValidation: \(needsValidation)")
        }
    }

    public func validateIfNeeded() {
        guard needsValidation else { return }
        validate()
    }

    public func setNeedsValidation() {
        needsValidation = true
        restartValidationTimer()
    }

    public var prevalidatedText: String? {
        guard let validator = validator else { return nil }
        return try? validator.submitValidate(text)
    }

    public func validate() {
        defer {
            needsValidation = false
        }

        guard let validator = validator else { return }

        cancelValidationTimer()
        do {
            validatedText = try validator.submitValidate(text)
            removeValidation()
            remoteValidate()
        } catch let error as ValidationError {
            validatedText = nil
            validationError = error
        } catch {
            validatedText = nil
            logError(error)
        }
    }

    public func remoteValidate() {
        guard let validator = validator else { return }

        currentRemoteValidation?.cancel()

        currentRemoteValidation = validator.remoteValidate(validatedText)?.then { _ in
            if let remoteValidationSuccessMessage = validator.remoteValidationSuccessMessage {
                self.validationMessage = .success(remoteValidationSuccessMessage)
            }
            }.catch { error in
                if let error = error as? ValidationError {
                    self.validatedText = nil
                    self.validationError = error
                }
            }.finally {
                self.currentRemoteValidation = nil
            }.run()
    }

    fileprivate func shouldChange(from startText: String, in range: NSRange, replacementText text: String) -> Bool {
        func _shouldChange() -> String? {
            // Don't allow any keyboard-based changes when entering dates
            switch contentType {
            case .date:
                return nil
            default:
                break
            }

            // Determine the final string
            let endText = startText.replacingCharacters(in: startText.stringRange(from: range)!, with: text)

            // Always allow deletions.
            guard !text.isEmpty else { return endText }

            // If disallowedCharaters is provided, disallow any changes that include characters in the set.
            if let disallowedCharacters = disallowedCharacters {
                guard text.rangeOfCharacter(from: disallowedCharacters) == nil else { return nil }
            }

            // If allowedCharacters is provided, disallow any changes that include characters not in the set.
            if let allowedCharacters = allowedCharacters {
                guard text.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return nil }
            }

            // Enforce the character limit, if any
            if let characterLimit = characterLimit {
                guard endText.count <= characterLimit else { return nil }
            }

            guard let validator = validator else { return endText }

            return validator.editValidate(endText)
        }

        guard let endText = _shouldChange() else { return false }
        guard endText != startText else { return false }

        if endText.isEmpty {
            removeValidation()
        } else {
            setNeedsValidation()
        }

        if startText != endText {
            setNeedsOnTextChanged()
        }

        return true
    }
}

extension PowerTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setEditing(true, animated: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        setEditing(false, animated: true)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startText = textField.text ?? ""
        return shouldChange(from: startText, in: range, replacementText: string)
    }
}

extension PowerTextField: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        setEditing(true, animated: true)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        setEditing(false, animated: true)
    }

    public func textViewDidChange(_ textView: UITextView) {
        syncToTextEditor(animated: true)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let startText = textView.text ?? ""
        return shouldChange(from: startText, in: range, replacementText: text)
    }
}
