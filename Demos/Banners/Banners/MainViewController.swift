//
//  MainViewController.swift
//  Banners
//
//  Created by Wolf McNally on 5/22/17.
//  Copyright © 2017 Arciem LLC. All rights reserved.
//

import UIKit
import WolfCore
import WolfBase

class MainViewController: BannerViewController {
  var tapAction: GestureRecognizerAction!
  private var publisher = Publisher<Bulletin>()

  override func setup() {
    super.setup()
    bulletinViewRegistry.register(bulletinType: MyMessageBulletin.self) {
      let myMessageBulletin = $0 as! MyMessageBulletin
      let view = MessageBulletinView(model: myMessageBulletin)
      view.skin.viewBackgroundColor = myMessageBulletin.backgroundColor
      return view
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //contentViewController = ContentViewController.instantiate()

    tapAction = contentViewController!.view.addAction(forGestureRecognizer: UITapGestureRecognizer()) { [unowned self] _ in
      self.perform()
    }
    subscribe(to: publisher)

    let vc = contentViewController as! ContentViewController
    vc.isDark = false
  }

  var reachability: Reachability!
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let endpoint = Endpoint(name: "Google", host: "google.com", basePath: "")
    reachability = Reachability(endpoint: endpoint)
    subscribe(to: reachability.publisher)
    reachability.start()

    perform()
  }

  private class MyMessageBulletin: MessageBulletin {
    let backgroundColor: Color

    init(title: String, message: String, priority: Int = normalPriority, duration: TimeInterval? = nil, backgroundColor: Color) {
      self.backgroundColor = backgroundColor
      super.init(title: title, message: message, priority: priority, duration: nil)
    }
  }

  private func perform() {
    let bulletin1 = MyMessageBulletin(title: "Banner 1", message: Lorem.shortSentence(), backgroundColor: Color.green.lightened(by: 0.8))
    let bulletin2 = MyMessageBulletin(title: "Banner 2", message: Lorem.sentences(3), backgroundColor: Color.yellow.lightened(by: 0.8))
    let bulletin3 = MyMessageBulletin(title: "Banner 3", message: Lorem.sentences(2), priority: 600, backgroundColor: Color.red.lightened(by: 0.8))
    let bulletin4 = MyMessageBulletin(title: "Banner 4", message: Lorem.shortSentence(), priority: 400, backgroundColor: Color.purple.lightened(by: 0.8))

    let multiplier: TimeInterval = 1.0

    dispatchOnMain(afterDelay: 0 * multiplier) {
      self.publisher.publish(bulletin1)
    }

    dispatchOnMain(afterDelay: 1 * multiplier) {
      self.publisher.publish(bulletin2)
    }

    dispatchOnMain(afterDelay: 2 * multiplier) {
      self.publisher.publish(bulletin3)
    }

    dispatchOnMain(afterDelay: 3 * multiplier) {
      self.publisher.publish(bulletin4)
    }

    dispatchOnMain(afterDelay: 4 * multiplier) {
      self.publisher.unpublish(bulletin3)
    }

    dispatchOnMain(afterDelay: 5 * multiplier) {
      self.publisher.unpublish(bulletin2)
    }

    dispatchOnMain(afterDelay: 6 * multiplier) {
      self.publisher.unpublish(bulletin1)
    }

    dispatchOnMain(afterDelay: 7 * multiplier) {
      self.publisher.unpublish(bulletin4)
    }
  }
}
