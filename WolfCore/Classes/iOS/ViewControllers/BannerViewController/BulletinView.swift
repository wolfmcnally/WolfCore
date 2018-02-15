//
//  BulletinView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit

public protocol BulletinViewProtocol: class {
    var bulletin: Bulletin { get set }
    var view: View { get }
}

public class BulletinView<B: Bulletin>: View {
    public typealias BulletinType = B

    public var specificBulletin: BulletinType! {
        didSet {
            syncToBulletin()
        }
    }

    open func syncToBulletin() {
    }

    public init(bulletin: BulletinType) {
        super.init(frame: .zero)
        self.specificBulletin = bulletin
        syncToBulletin()
    }

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension BulletinView: BulletinViewProtocol {
    public var bulletin: Bulletin {
        get {
            return specificBulletin!
        }
        set {
            specificBulletin = newValue as! BulletinType
        }
    }

    public var view: View {
        return self
    }
}
