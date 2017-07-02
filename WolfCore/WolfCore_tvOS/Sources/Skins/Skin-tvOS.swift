//
//  Skin.swift
//  WolfCore_macOS
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import WolfBase

extension SkinKey {
  public static let bookStyle = SkinKey("bookStyle")
  public static let titleStyle = SkinKey("titleStyle")

  public static let viewBackgroundColor = SkinKey("viewBackgroundColor")
  public static let viewControllerBackgroundColor = SkinKey("viewControllerBackgroundColor")
  public static let tintColor = SkinKey("tintColor")
  public static let highlightedTintColor = SkinKey("highlightedTintColor")
  public static let textColor = SkinKey("textColor")
  public static let disabledColor = SkinKey("disabledColor")

  public static let labelStyle = SkinKey("labelStyle")

  public static let buttonTitleStyle = SkinKey("buttonTitleStyle")

  public static let topbarColor = SkinKey("topbarColor")
  public static let topbarTitleStyle = SkinKey("topbarTitleStyle")
  public static let topbarBlur = SkinKey("topbarBlur")
  public static let topbarTitleColor = SkinKey("topbarTitleColor")
  public static let topbarTintColor = SkinKey("topbarTintColor")

  public static let bottombarColor = SkinKey("bottombarColor")
  public static let bottombarItemColor = SkinKey("bottombarItemColor")
  public static let bottombarTintColor = SkinKey("bottombarTintColor")

  public static let textFieldContentStyle = SkinKey("textFieldContentStyle")
  public static let textFieldPlaceholderStyle = SkinKey("textFieldPlaceholderStyle")
  public static let textFieldCounterStyle = SkinKey("textFieldCounterStyle")
  public static let textFieldPlaceholderMessageStyle = SkinKey("textFieldPlaceholderMessageStyle")
  public static let textFieldValidationFailureMessageStyle = SkinKey("textFieldValidationFailureMessageStyle")
  public static let textFieldValidationSuccessMessageStyle = SkinKey("textFieldValidationSuccessMessageStyle")
  public static let textFieldIconTintColor = SkinKey("textFieldIconTintColor")
  public static let textFieldFrameColor = SkinKey("textFieldFrameColor")

  public static let currentPageIndicatorTintColor = SkinKey("currentPageIndicatorTintColor")
  public static let pageIndicatorTintColor = SkinKey("pageIndicatorTintColor")
}

extension Skin {
  public var viewBackgroundColor: Color {
    get { return get(.viewBackgroundColor, .clear) }
    set { set(.viewBackgroundColor, to: newValue) }
  }
  public var viewControllerBackgroundColor: Color {
    get { return get(.viewControllerBackgroundColor, .white) }
    set { set(.viewControllerBackgroundColor, to: newValue) }
  }
  public var tintColor: Color {
    get { return get(.tintColor, Color(defaultTintColor)) }
    set { set(.tintColor, to: newValue) }
  }
  public var highlightedTintColor: Color {
    get { return get(.tintColor, tintColor.withAlpha(0.5)) }
    set { set(.tintColor, to: newValue) }
  }
  public var textColor: Color {
    get { return get(.textColor, .black) }
    set { set(.textColor, to: newValue) }
  }
  public var disabledColor: Color {
    get { return get(.disabledColor, Color(color: .gray, alpha: 0.3)) }
    set { set(.disabledColor, to: newValue) }
  }
  public var bookStyle: FontStyle {
    get { return get(.bookStyle, FontStyle(.bookStyle, font: .systemFont(ofSize: 12))) }
    set { set(.bookStyle, to: newValue) }
  }
  public var titleStyle: FontStyle {
    get { return get(.titleStyle, FontStyle(.titleStyle, font: .boldSystemFont(ofSize: 24))) }
    set { set(.titleStyle, to: newValue) }
  }


  public var buttonTitleStyle: FontStyle {
    get { return get(.buttonTitleStyle, FontStyle(.buttonTitleStyle, font: .systemFont(ofSize: 12))) }
    set { set(.buttonTitleStyle, to: newValue) }
  }

  public var topbarTitleStyle: FontStyle {
    get { return get(.topbarTitleStyle, FontStyle(.topbarTitleStyle, font: .boldSystemFont(ofSize: 16))) }
    set { set(.topbarTitleStyle, to: newValue) }
  }
  public var topbarColor: Color {
    get { return get(.topbarColor, Color(color: .gray, alpha: 0.3)) }
    set { set(.topbarColor, to: newValue) }
  }
  public var topbarBlur: Bool {
    get { return get(.topbarBlur, true) }
    set { set(.topbarBlur, to: newValue) }
  }
  public var topbarTitleColor: Color {
    get { return get(.topbarTitleColor, .black) }
    set { set(.topbarTitleColor, to: newValue) }
  }
  public var topbarTintColor: Color {
    get { return get(.topbarTintColor, tintColor) }
    set { set(.topbarTintColor, to: newValue) }
  }

  public var bottombarColor: Color {
    get { return get(.bottombarColor, topbarColor) }
    set { set(.bottombarColor, to: newValue) }
  }
  public var bottombarItemColor: Color {
    get { return get(.bottombarItemColor, topbarTitleColor) }
    set { set(.bottombarItemColor, to: newValue) }
  }
  public var bottombarTintColor: Color {
    get { return get(.bottombarTintColor, topbarTintColor) }
    set { set(.bottombarTintColor, to: newValue) }
  }

  public var labelStyle: FontStyle {
    get { return get(.labelStyle, bookStyle.withColor(textColor, .textColor)) }
    set { set(.labelStyle, to: newValue) }
  }

  public var textFieldContentStyle: FontStyle {
    get { return get(.textFieldContentStyle, bookStyle.withColor(textColor, .textColor)) }
    set { set(.textFieldContentStyle, to: newValue) }
  }
  public var textFieldPlaceholderStyle: FontStyle {
    get { return get(.textFieldPlaceholderStyle, bookStyle.withColor(.gray, "gray")) }
    set { set(.textFieldPlaceholderStyle, to: newValue) }
  }
  public var textFieldCounterStyle: FontStyle {
    get { return get(.textFieldCounterStyle, FontStyle(.textFieldCounterStyle, font: .italicSystemFont(ofSize: 8), color: .darkGray)) }
    set { set(.textFieldCounterStyle, to: newValue) }
  }
  public var textFieldPlaceholderMessageStyle: FontStyle {
    get { return get(.textFieldPlaceholderMessageStyle, FontStyle(.textFieldPlaceholderMessageStyle, font: .italicSystemFont(ofSize: 8), color: .gray)) }
    set { set(.textFieldPlaceholderMessageStyle, to: newValue) }
  }
  public var textFieldValidationFailureMessageStyle: FontStyle {
    get { return get(.textFieldValidationFailureMessageStyle, FontStyle(.textFieldValidationFailureMessageStyle, font: .italicSystemFont(ofSize: 8), color: .red)) }
    set { set(.textFieldValidationFailureMessageStyle, to: newValue) }
  }
  public var textFieldValidationSuccessMessageStyle: FontStyle {
    get { return get(.textFieldValidationSuccessMessageStyle, FontStyle(.textFieldValidationSuccessMessageStyle, font: .italicSystemFont(ofSize: 8), color: .green)) }
    set { set(.textFieldValidationSuccessMessageStyle, to: newValue) }
  }
  public var textFieldIconTintColor: Color {
    get { return get(.textFieldIconTintColor, textColor) }
    set { set(.textFieldIconTintColor, to: newValue) }
  }
  public var textFieldFrameColor: Color {
    get { return get(.textFieldFrameColor, textColor) }
    set { set(.textFieldFrameColor, to: newValue) }
  }

  public var currentPageIndicatorTintColor: Color {
    get { return get(.currentPageIndicatorTintColor, .black) }
    set { set(.currentPageIndicatorTintColor, to: newValue) }
  }
  public var pageIndicatorTintColor: Color {
    get { return get(.pageIndicatorTintColor, currentPageIndicatorTintColor.withAlpha(0.3)) }
    set { set(.pageIndicatorTintColor, to: newValue) }
  }
}

extension ConcreteSkin {
  public mutating func applyDefaults() {
    addIdentifier("light")

    SkinKey.tintColor => [
      .highlightedTintColor,
      .topbarTintColor
    ]

    SkinKey.currentPageIndicatorTintColor => [
      .pageIndicatorTintColor
    ]

    SkinKey.textColor => [
      .labelStyle,
      .textFieldContentStyle,
      .textFieldIconTintColor,
      .textFieldFrameColor
    ]

    SkinKey.bookStyle => [
      .labelStyle,
      .textFieldContentStyle,
      .textFieldPlaceholderStyle
    ]
  }

  public mutating func applyDarkDefaults() {
    applyDefaults()

    addIdentifier("dark")
    variant = .darkBackground

    viewControllerBackgroundColor = .black
    textColor = .white
    currentPageIndicatorTintColor = .white
    labelStyle.color = .white
    textFieldContentStyle.color = .white
  }
}


