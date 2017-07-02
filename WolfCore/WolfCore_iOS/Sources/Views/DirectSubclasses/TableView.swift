//
//  TableView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/14/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public class TableView: UITableView, Skinnable {
  public convenience init() {
    self.init(frame: .zero)
  }
  
  public override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: .plain)
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
  
  open func setup() { }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
  }
}
