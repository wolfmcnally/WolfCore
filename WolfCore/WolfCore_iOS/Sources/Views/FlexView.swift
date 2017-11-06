//
//  FlexView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/14/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import UIKit
import WolfBase

public enum FlexContent {
    case string(String)
    case image(UIImage)
    case imageString(UIImage, String)
}

public class FlexView: View {
    public var content: FlexContent? {
        didSet {
            sync()
        }
    }
    
    private var horizontalStackView: HorizontalStackView = {
        let view = HorizontalStackView()
        return view
    }()
    
    public private(set) var label: Label!
    public private(set) var imageView: ImageView!
    
    public init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func setup() {
        super.setup()
        isUserInteractionEnabled = false
        self => [
            horizontalStackView
        ]
        horizontalStackView.constrainFrameToFrame()
        horizontalStackView.setPriority(crH: .required)
    }
    
    private func removeContentViews() {
        horizontalStackView.removeAllSubviews()
        label = nil
        imageView = nil
    }
    
    private func setContentViews(_ views: [UIView]) {
        horizontalStackView => views
    }
    
    private func sync() {
        removeContentViews()
        
        switch content {
            
        case .string(let text)?:
            label = Label()
            label.text = text
            setContentViews([label])
            
        case .image(let image)?:
            imageView = ImageView()
            imageView.image = image
            setContentViews([imageView])
            
        case .imageString(let image, let string)?:
            label = Label()
            imageView = ImageView()
            label.text = string
            imageView.image = image
            setContentViews([imageView, label])
            
        case nil:
            break
        }
    }
}
