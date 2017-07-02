//
//  ResourceUtils-iOS.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/25/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public func loadViewController<T: UIViewController>(withIdentifier identifier: String, fromStoryboardNamed storyboardName: String, in bundle: Bundle? = nil) -> T {
  let storyboard = loadStoryboard(named: storyboardName, in: bundle)
  return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}

public func loadViewController<T: UIViewController>(withIdentifier identifier: String, from storyboard: UIStoryboard) -> T {
  return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}

public func loadInitialViewController<T: UIViewController>(fromStoryboardNamed storyboardName: String, in bundle: Bundle? = nil) -> T {
  let storyboard = loadStoryboard(named: storyboardName, in: bundle)
  return storyboard.instantiateInitialViewController() as! T
}
