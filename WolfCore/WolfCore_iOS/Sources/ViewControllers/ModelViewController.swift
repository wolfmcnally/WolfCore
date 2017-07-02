//
//  ModelViewController.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/21/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

open class ModelViewController<M>: ViewController, ModelObject {
  public typealias Model = M
  public typealias ModelBlock = (Model) -> Void
  
  public var model: Model! {
    didSet {
      syncToModel()
    }
  }
  
  open func syncToModel() {
  }
}
