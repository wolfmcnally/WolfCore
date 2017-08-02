//
//  SkinnableUIViewControllerExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

extension LogGroup {
  public static let skinC = LogGroup("skinC")
}

extension UIViewController {
  fileprivate var privateSkin: Skin? {
    get {
      return getAssociatedValue(for: &SkinnableAssociatedKeys.privateSkin)
    }
    
    set {
      setAssociatedValue(newValue, for: &SkinnableAssociatedKeys.privateSkin)
    }
  }
}

extension UIViewController {
  public var skin: Skin! {
    get {
      guard skinsEnabled else { return nil }
      if let s = privateSkin {
        return s
      } else {
        return topSkin
      }
    }
    
    set {
      set(skin: newValue)
    }
  }
}

extension UIViewController {
  public func _reviseSkin(_ skin: Skin) -> Skin? {
    return nil
  }
  
  public func _applySkin(_ skin: Skin) {
    func newSwatch(with color: UIColor) -> UIImage {
      return newImage(withSize: CGSize(width: 16, height: 16), background: color, drawing: { context in })
    }
    
    func applyTo(viewController: UIViewController) {
      viewController.view.backgroundColor ©= skin.viewControllerBackgroundColor
    }
    
    func applyTo(navigationController: UINavigationController) {
      #if !os(tvOS)
        if navigationController.isNavigationBarHidden != skin.navigationBarHidden {
          navigationController.setNavigationBarHidden(skin.navigationBarHidden, animated: true)
        }

        let navigationBar = navigationController.navigationBar
        navigationBar.isTranslucent = true
        logTrace("topbarColor: \(skin.topbarColor) from: \(skin.identifierPath))", obj: self, group: .statusBar)
        let image = newSwatch(with: skin.topbarColor.osColor)
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.tintColor ©= skin.topbarTintColor
        navigationBar.titleTextAttributes = [
          .font: skin.topbarTitleStyle.font,
          .foregroundColor: skin.topbarTitleColor.osColor
        ]

        // Remove bottom bevel
        navigationBar.shadowImage = UIImage()

        if let toolbar = navigationController.toolbar {
          toolbar.isTranslucent = true
          let image = newSwatch(with: skin.bottombarColor.osColor)
          toolbar.setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
          toolbar.tintColor ©= skin.bottombarTintColor
        }

        if let navigationController = navigationController as? NavigationController {
          navigationController.isBlurred = skin.topbarBlur
        }
      #endif
    }
    
    func applyTo(tabBarController: UITabBarController) {
      let tabBar = tabBarController.tabBar
      tabBar.isTranslucent = true
      let image = newSwatch(with: skin.bottombarColor.osColor)
      tabBar.backgroundImage = image
      if let items = tabBar.items {
        for item in items {
          if let image = item.image {
            item.image = image.tinted(withColor: skin.bottombarItemColor.osColor)
            item.selectedImage = image.tinted(withColor: skin.bottombarTintColor.osColor)
            item.setTitleTextAttributes([.foregroundColor: skin.bottombarItemColor.osColor], for: .normal)
            item.setTitleTextAttributes([.foregroundColor: skin.bottombarTintColor.osColor], for: .selected)
          }
        }
      }
    }

    #if !os(tvOS)
      logTrace("applySkin \(skin.identifierPath)", obj: self, group: .statusBar)
      setNeedsStatusBarAppearanceUpdate()
    #endif
    
    if isViewLoaded {
      applyTo(viewController: self)
      
      switch self {
      case let navigationController as UINavigationController:
        applyTo(navigationController: navigationController)
      case let tabBarController as UITabBarController:
        applyTo(tabBarController: tabBarController)
      default:
        break
      }
    }
  }

  #if !os(tvOS)
    public func _preferredStatusBarStyle(for skin: Skin?) -> UIStatusBarStyle {
      guard skinsEnabled else { return .default }
      let style = skin?.statusBarStyle ?? .default
      logTrace("style: \(style.rawValue)", obj: self, group: .statusBar)
      return style
    }
  #endif
}

extension UIViewController {
  fileprivate func set(skin: Skin!) {
    skinIndentLevel += 1
    defer { skinIndentLevel -= 1 }
    
    logTrace("📳 💖 set \(self††) to \(skin.identifierPath)".indented(skinIndentLevel), group: .skinC)
    
    privateSkin = skin
    let s = (skin ?? self.skin)!
    propagate(skin: s)
  }
  
  fileprivate func propagate(skin inSkin: Skin) {
    skinIndentLevel += 1
    defer { skinIndentLevel -= 1 }
    
    var outSkin = inSkin
    
    if let skinnable = self as? Skinnable {
      if let revisedSkin = skinnable.reviseSkin(inSkin) {
        outSkin = revisedSkin
        privateSkin = outSkin
        logTrace("📳 💘 \(self††) revised to \(outSkin.identifierPath)".indented(skinIndentLevel), group: .skinC)
      } else {
        logTrace("📳 💚 \(self††) kept \(outSkin.identifierPath)".indented(skinIndentLevel), group: .skinC)
      }
      skinnable.applySkin(outSkin)
    } else {
      logTrace("📳 🖤 \(self††) isn't skinnable".indented(skinIndentLevel), group: .skinC)
    }
    
    if isViewLoaded {
      logTrace("📳 💟 \(self††) setting \(view!††) to \(outSkin.identifierPath)".indented(skinIndentLevel), group: .skinC)
      view!.set(skin: outSkin)
    } else {
      logTrace("📳 💟 ⛔️ \(self††) isn't loaded".indented(skinIndentLevel), group: .skinC)
    }
  }
  
  public func propagateSkin(why: String) {
    guard skinsEnabled else { return }
    skinIndentLevel += 1
    defer { skinIndentLevel -= 1 }
    
    let skin = self.skin!
    logTrace("📳 \(self††) propagating \(skin.identifierPath) [\(why)]".indented(skinIndentLevel), group: .skinC)
    propagate(skin: skin)
  }
}
