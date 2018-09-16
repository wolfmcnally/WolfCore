//
//  VectorNode.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation
import SpriteKit
import WolfColor

public class VectorNode: SKShapeNode {
    public var vector: CGVector? {
        didSet {
            sync()
        }
    }

    public var color: OSColor {
        didSet {
            sync()
        }
    }

    public init(vector: CGVector? = nil, color: OSColor = .red) {
        self.vector = vector
        self.color = color
        super.init()
        lineWidth = 2.0
    }

    public override func move(toParent parent: SKNode) {
        super.move(toParent: parent)
        sync()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func sync() {
        if let vector = vector {
            let path = CGMutablePath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(vector: vector))
            strokeColor = color
            self.path = path
            show()
        } else {
            hide()
        }
    }
}
