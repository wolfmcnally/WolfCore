//
//  SpriteKitExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation
import SpriteKit
import AVFoundation

open class SpriteNode: SKSpriteNode {
    public init(image: OSImage) {
        let texture = SKTexture(image: image)
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKNode {
    public var sceneZRotation: CGFloat {
        var r: CGFloat = 0
        var curNode: SKNode! = self
        repeat {
            r -= curNode.zRotation
            curNode = curNode.parent
        } while curNode != nil
        return r
    }
}

extension SKNode: Hideable { }
