//
//  Label.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/22/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

#if !os(macOS)
  import UIKit
  public typealias OSLabel = UILabel
#else
  import Cocoa
  public typealias OSLabel = NSTextField
#endif

import WolfBase

public typealias TagAction = (String) -> Void

open class Label: OSLabel, Skinnable {
  #if os(macOS)
  public var text: String {
  get {
  return stringValue
  }
  set {
  stringValue = newValue
  }
  }
  #else
  var tagTapActions = [NSAttributedStringKey: TagAction]()
  var tapAction: GestureRecognizerAction!
  
  @IBInspectable public var scalesFontSize: Bool = false
  @IBInspectable public var isTransparentToTouches: Bool = false
  
  private var baseFont: UIFontDescriptor!
  
  public func resetBaseFont() {
    guard scalesFontSize else { return }
    
    baseFont = font.fontDescriptor
  }
  
  public func syncFontSize(toFactor factor: CGFloat) {
    guard scalesFontSize else { return }
    
    let pointSize = baseFont.pointSize * factor
    font = UIFont(descriptor: baseFont, size: pointSize)
  }
  
  open override var text: String? {
    didSet {
      guard skinsEnabled else { return }
      syncToSkin(skin)
    }
  }
  
  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if isTransparentToTouches {
      return isTransparentToTouch(at: point, with: event)
    } else {
      return super.point(inside: point, with: event)
    }
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    text = text?.localized(onlyIfTagged: true)
  }
  
  #endif
  
  public convenience init() {
    self.init(frame: .zero)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    _setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
  }
  
  private func _setup() {
    __setup()
    setup()
  }
  
  public var fontStyle: FontStyle {
    get { return skin.labelStyle }
    set {
      var s = skin!
      s.labelStyle = newValue
      s.addIdentifier("label(\(newValue.identifierPath))")
      skin = s
    }
  }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
    syncToSkin(skin)
  }
  
  private func syncToSkin(_ skin: Skin) {
    guard skinsEnabled else { return }
    let style = skin.labelStyle
    textColor ©= style.color
    font = style.font
    attributedText = style.apply(to: text)
  }
  
  public var drawAtTop = false {
    didSet {
      setNeedsDisplay()
    }
  }
  
  open func setup() { }
}

#if !os(macOS)
  
  extension Label {
    public func setTapAction(forTag tag: NSAttributedStringKey, action: @escaping TagAction) {
      tagTapActions[tag] = action
      syncToTagTapActions()
    }
    
    public func removeTapAction(forTag tag: NSAttributedStringKey) {
      tagTapActions[tag] = nil
      syncToTagTapActions()
    }
    
    private func syncToTagTapActions() {
      if tagTapActions.count == 0 {
        tapAction = nil
      } else {
        if tapAction == nil {
          isUserInteractionEnabled = true
          
          tapAction = addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] recognizer in
            self.handleTap(fromRecognizer: recognizer)
          }
        }
      }
    }
    
    private func handleTap(fromRecognizer recognizer: UIGestureRecognizer) {
      let layoutManager = NSLayoutManager()
      let textContainer = NSTextContainer()
      let textStorage = NSTextStorage(attributedString: attributedText!)
      layoutManager.addTextContainer(textContainer)
      textStorage.addLayoutManager(layoutManager)
      textContainer.lineFragmentPadding = 0.0
      textContainer.lineBreakMode = lineBreakMode
      textContainer.maximumNumberOfLines = numberOfLines
      textContainer.size = bounds.size
      
      let locationOfTouchInLabel = recognizer.location(in: self)
      let labelSize = bounds.size
      let textBoundingBox = layoutManager.usedRect(for: textContainer)
      let textContainerOffset = (labelSize - textBoundingBox.size) * 0.5 - textBoundingBox.minXminY
      let locationOfTouchInTextContainer = CGPoint(vector: locationOfTouchInLabel - textContainerOffset)
      let charIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
      if charIndex < textStorage.length {
        let attributedText = (self.attributedText!)§
        for (tag, action) in tagTapActions {
          let index = attributedText.string.index(fromLocation: charIndex)
          if let tappedText = attributedText.getString(forTag: tag, atIndex: index) {
            action(tappedText)
          }
        }
      }
    }
  }
#endif
