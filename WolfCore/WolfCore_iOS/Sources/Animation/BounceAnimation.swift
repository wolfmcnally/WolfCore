//
//  BounceAnimation.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/5/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public class BounceAnimation {
  private unowned let view: UIView
  private var isReleased = false
  
  public init(view: UIView) {
    self.view = view
  }
  
  public func animateDown() {
    isReleased = false
    dispatchAnimated(duration: 0.1, options: [.beginFromCurrentState, .curveEaseOut]) {
      self.view.transform = .init(scaleX: 0.7, y: 0.7)
      }.run()
  }
  
  public func animateUp() {
    guard !isReleased else { return }
    dispatchAnimated(duration: 0.1, options: [.beginFromCurrentState, .curveEaseInOut]) {
      self.view.transform = .identity
      }.run()
  }
  
  private var completion: Block?
  
  public func animateRelease(completion: Block? = nil) {
    isReleased = true
    self.completion = completion
    UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 40.0, options: [.allowUserInteraction], animations: {
      self.view.transform = .identity
    }, completion: { _ in
    }
    )
    
    dispatchOnMain(afterDelay: 0.25) {
      self.completion?()
    }
  }
  
  public func animate(oldHighlighted: Bool, newHighlighted: Bool) {
    guard oldHighlighted != newHighlighted else { return }
    if newHighlighted == true {
      animateDown()
    } else if newHighlighted == false {
      animateUp()
    }
  }
  
  public func animate(oldSelected: Bool, newSelected: Bool) {
    guard oldSelected != newSelected else { return }
    if newSelected == true {
      animateRelease()
    }
  }
}
