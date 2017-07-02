//
//  OverlayWindow.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

private var _overlayWindow: OverlayWindow?
public var overlayWindow: OverlayWindow! {
  get {
    if _overlayWindow == nil {
      _overlayWindow = OverlayWindow()
    }
    return _overlayWindow
  }
  
  set {
    _overlayWindow = newValue
  }
}

public var overlayView: View {
  return overlayWindow!.subviews[0] as! View
}

public func removeOverlayWindow() {
  overlayWindow = nil
}

public class OverlayWindow: UIWindow {
  public init() {
    super.init(frame: .zero)
    _setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
  }
  
  private func _setup() {
    __setup()
    
    windowLevel = UIWindowLevelAlert + 100
    frame = UIScreen.main.bounds
    rootViewController = OverlayViewController()
    show()
    setup()
  }
  
  open func setup() { }
  
  override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return isTransparentToTouch(at: point, with: event)
  }
}

public class OverlayViewController: ViewController {
  public override func loadView() {
    let v = View()
    v.isTransparentToTouches = true
    v.translatesAutoresizingMaskIntoConstraints = true
    view = v
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.makeTransparent()
  }
}
