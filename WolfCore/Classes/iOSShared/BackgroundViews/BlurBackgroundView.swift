//
//  BlurBackgroundView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/7/18.
//

public class BlurBackgroundView: BackgroundView {
    public var cornerRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    public override var insets: UIEdgeInsets {
        return RoundedCornersBorder.makeInsets(for: cornerRadius, lineWidth: 0)
    }

    public var blurEffectStyle: UIBlurEffectStyle! {
        didSet { syncAppearance() }
    }

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var blurView: UIVisualEffectView = {
        let style: UIBlurEffectStyle

        if #available(iOS 10.0, *) {
            style = .regular
        } else {
            style = .light
        }

        return ‡UIVisualEffectView(effect: UIBlurEffect(style: style))
    }()

    public override func setup() {
        super.setup()

        layer.masksToBounds = true

        self => [
            blurView
        ]

        blurView.constrainFrameToFrame()
    }

    private func syncAppearance() {
        blurView.effect = UIBlurEffect(style: blurEffectStyle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(cornerRadius, bounds.size.min / 2)
    }
}
