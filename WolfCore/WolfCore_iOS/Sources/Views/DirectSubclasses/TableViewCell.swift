//
//  TableViewCell.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

open class TableViewCell: UITableViewCell, Skinnable {
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _setup()
  }
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    _setup()
  }
  
  public init(reuseIdentifier: String = "none") {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
  }
  
  private func _setup() {
    setup()
  }
  
  open func reviseSkin(_ skin: Skin) -> Skin? {
    return _reviseSkin(skin)
  }
  
  open func applySkin(_ skin: Skin) {
    _applySkin(skin)
  }
  
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard superview != nil else { return }
    propagateSkin(why: "didMoveToSuperview")
  }
  
  open func setup() { }
  
  //    private let heightEstimator = RunningAverage<CGFloat>()
  //
  //    public var estimatedHeight: CGFloat? {
  //        return heightEstimator.value
  //    }
  
  //    open override func layoutSubviews() {
  //        super.layoutSubviews()
  //        print("height: \(bounds.height)")
  ////        heightEstimator.update(bounds.height)
  //    }
}
