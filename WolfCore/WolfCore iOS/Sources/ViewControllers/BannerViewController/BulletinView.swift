//
//  BulletinView.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public protocol BulletinViewProtocol: class {
    var bulletin: Bulletin { get set }
    var view: View { get }
}

public class BulletinView<B: Bulletin>: ModelView<B> {
}

extension BulletinView: BulletinViewProtocol {
    public var bulletin: Bulletin {
        get {
            return model!
        }
        set {
            model = newValue as! Model
        }
    }
    
    public var view: View {
        return self
    }
}
