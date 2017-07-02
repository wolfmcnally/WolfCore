//
//  MainViewController.swift
//  TableLayout
//
//  Created by Robert McNally on 7/6/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore
import WolfBase

class MainViewController: ViewController {
  @IBOutlet weak var tableView: TableView!
  
  let modelsCount = 100
  
  let minHeight = 50
  let maxHeight = 250
  
  let minWidth = 100
  let maxWidth = 250
  
  lazy var avgHeight: CGFloat = CGFloat(0.5).lerpedFromFrac(to: CGFloat(self.minHeight)..CGFloat(self.maxHeight))
  
  var models = [Model]()
  
  fileprivate func newModel(with index: Int) -> Model {
    let color = Color.random()
    let width = Random.number(minWidth..<maxWidth)
    let height = Random.number(minHeight..<maxHeight)
    let size = CGSize(width: width, height: height)
    return Model(index: index, color: color, size: size)
  }
  
  fileprivate func setupModels() {
    for index in 0..<modelsCount {
      models.append(newModel(with: index))
    }
  }
  
  fileprivate func setupTable() {
    tableView.setupDynamicRowHeights(withEstimatedRowHeight: avgHeight)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupModels()
    setupTable()
  }
  
  fileprivate func changeModel(for cell: MyTableViewCell, at indexPath: IndexPath) {
    let index = cell.model.index
    let model = self.newModel(with: index)
    self.models[index] = model
    tableView.syncDynamicContent(of: cell, scrollingToVisibleAt: indexPath) {
      cell.model = model
    }
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell") as! MyTableViewCell
    let index = indexPath.item
    cell.model = models[index]
    cell.touchAction = { [unowned self] in
      self.changeModel(for: cell, at: indexPath)
    }
    return cell
  }
}
