//
//  PagingView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/17/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

import UIKit

class PagingContentView: View { }

open class PagingView: View {
    public typealias IndexDispatchBlock = (Int) -> Void

    public var arrangedViewAtIndexDidBecomeVisible: IndexDispatchBlock?
    public var arrangedViewAtIndexDidBecomeInvisible: IndexDispatchBlock?

    public var onWillBeginDragging: Block?
    public var onDidEndDragging: Block?
    public var onDidLayout: ((_ fromIndex: Int, _ toIndex: Int, _ frac: Frac) -> Void)?

    public private(set) var scrollingFromIndex: Int = 0
    public private(set) var scrollingToIndex: Int = 0
    public private(set) var scrollingFrac: Frac = 0.0
    public private(set) var pageControl: PageControl!

    public var hidesPagingControlForOnePage = false {
        didSet {
            syncPageControlToContentView()
        }
    }

    private var scrollView: ScrollView!
    private var contentView: PagingContentView!
    private var contentWidthConstraint: NSLayoutConstraint!
    private var arrangedViewsLeadingConstraints = [NSLayoutConstraint]()

    public var bottomView: UIView! {
        willSet {
            bottomView?.removeFromSuperview()
        }

        didSet {
        }
    }

    private var visibleViewIndexes = Set<Int>() {
        willSet {
            let added = newValue.subtracting(visibleViewIndexes)
            let removed = visibleViewIndexes.subtracting(newValue)
            for index in added {
                arrangedViewAtIndexDidBecomeVisible?(index)
            }
            for index in removed {
                arrangedViewAtIndexDidBecomeInvisible?(index)
            }
        }
    }

    public func setPageControl(isHidden: Bool, animated: Bool = true) {
        guard pageControl.isHidden != isHidden else {
            return
        }

        pageControl.show()

        dispatchAnimated {
            if isHidden {
                self.pageControl.alpha = 0.0
            } else {
                self.pageControl.alpha = 1.0
            }
            }.run { _ in
                self.pageControl.hideIf(isHidden)
        }
    }

    public var arrangedViews: [UIView] {
        get {
            return contentView.subviews
        }

        set {
            removeArrangedViews()
            addArrangedViews(newValue)
            syncPageControlToContentView()
            updateContentSize()
            setNeedsLayout()
        }
    }

    public var currentPage: Int {
        get {
            return pageControl.currentPage
        }

        set {
            scroll(toPage: newValue)
        }
    }

    public func scroll(toPage page: Int, animated: Bool = true) {
        let destFrame = arrangedViews[page].frame
        let x = destFrame.minX
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }

    public func scrollToNextPage(animated: Bool = true) {
        let nextPage = arrangedViews.circularIndex(at: currentPage + 1)
        scroll(toPage: nextPage, animated: animated)
    }

    public func scrollToPreviousPage(animated: Bool = true) {
        let previousPage = arrangedViews.circularIndex(at: currentPage - 1)
        scroll(toPage: previousPage, animated: animated)
    }

    private var previousSize: CGSize?

    open override func layoutSubviews() {
        let page = currentPage
        updateArrangedViewConstraints()
        scrollView.layoutIfNeeded()

        super.layoutSubviews()

        updateVisibleArrangedViews()
        updatePageControl()
        updateFractionalPage()

        if let previousSize = previousSize {
            if previousSize != bounds.size {
                scroll(toPage: page, animated: false)
            }
        }
        previousSize = bounds.size

        onDidLayout?(scrollingFromIndex, scrollingToIndex, scrollingFrac)
    }

    open override func updateConstraints() {
        super.updateConstraints()
        updateArrangedViewConstraints()
    }

    open override var clipsToBounds: Bool {
        didSet {
            scrollView.clipsToBounds = clipsToBounds
        }
    }

    open override func setup() {
        super.setup()

        setupScrollView()
        setupPageControl()
    }

    private func removeArrangedViews() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        arrangedViewsLeadingConstraints.removeAll()
    }

    private func addArrangedViews(_ newViews: [UIView]) {
        for view in newViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView => [
                view
            ]
            let leadingConstraint = view.leadingAnchor == contentView.leadingAnchor
            arrangedViewsLeadingConstraints.append(leadingConstraint)
            Constraints(
                view.topAnchor == topAnchor,
                view.heightAnchor == heightAnchor,
                view.widthAnchor == widthAnchor,
                leadingConstraint
            )
        }
    }

    private func updateContentSize() {
        contentWidthConstraint.isActive = false
        contentWidthConstraint = contentView.widthAnchor == widthAnchor * CGFloat(arrangedViews.count)
        contentWidthConstraint.isActive = true
    }

    private func setupScrollView() {
        scrollView = ScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false

        #if !os(tvOS)
            scrollView.isPagingEnabled = true
        #endif

        contentView = PagingContentView()

        self => [
            scrollView => [
                contentView
            ]
        ]

        scrollView.constrainFrameToFrame(identifier: "pagingScroll")

        contentView.constrainFrameToFrame(identifier: "pagingScrollContent")
        contentWidthConstraint = contentView.widthAnchor == 500
        let contentHeightConstraint = contentView.heightAnchor == heightAnchor - 0.5
        Constraints(
            contentWidthConstraint,
            contentHeightConstraint
        )
    }

    private func setupPageControl() {
        pageControl = PageControl()
        pageControl.isUserInteractionEnabled = false
        self => [
            pageControl
        ]
        Constraints(
            pageControl.centerXAnchor == centerXAnchor =&= .defaultLow,
            pageControl.heightAnchor == 40.0, // =&= .defaultLow,
            pageControl.bottomAnchor == bottomAnchor - 20 =&= .defaultLow
        )
    }

    private func concealPageControl(animated: Bool) {
        if !pageControl.isHidden {
            pageControl.hide(animated: animated)
        }
    }

    private func revealPageControl(animated: Bool) {
        if pageControl.isHidden {
            pageControl.show(animated: animated)
        }
    }

    private func syncPageControlToContentView() {
        let numberOfPages = arrangedViews.count
        pageControl.numberOfPages = numberOfPages
        if hidesPagingControlForOnePage && numberOfPages <= 1 {
            concealPageControl(animated: true)
        } else {
            revealPageControl(animated: true)
        }
    }

    private func updateArrangedViewConstraints() {
        guard bounds.width > 0 else {
            return
        }

        for index in 0..<arrangedViews.count {
            let x = CGFloat(index) * bounds.width
            arrangedViewsLeadingConstraints[index].constant = x
            arrangedViews[index].setNeedsLayout()
        }
        contentView.setNeedsLayout()
    }

    private func updateVisibleArrangedViews() {
        var newVisibleViewIndexes = Set<Int>()
        for (index, view) in arrangedViews.enumerated() {
            let r = convert(view.bounds, from: view)
            if r.intersects(bounds) {
                newVisibleViewIndexes.insert(index)
            }
        }
        visibleViewIndexes = newVisibleViewIndexes
    }

    private func updatePageControl() {
        let x = scrollView.contentOffset.x
        let fractionalPosition = x / scrollView.bounds.width
        let page = Int(fractionalPosition + 0.5)
        let circularPage = arrangedViews.circularIndex(at: page)
        pageControl.currentPage = circularPage
    }

    private func updateFractionalPage() {
        let x = scrollView.contentOffset.x
        if x < 0 {
            scrollingFromIndex = 0
            scrollingToIndex = 0
            scrollingFrac = 0.0
        } else if x > contentView.bounds.width - scrollView.bounds.width {
            scrollingFromIndex = arrangedViews.count - 1
            scrollingToIndex = arrangedViews.count - 1
            scrollingFrac = 0.0
        } else {
            let fractionalPosition = x / scrollView.bounds.width
            scrollingFrac = Frac(fractionalPosition.truncatingRemainder(dividingBy: 1.0))
            scrollingFromIndex = Int(fractionalPosition.rounded(.down))
            scrollingToIndex = scrollingFromIndex + 1
        }
    }
}

extension PagingView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_: UIScrollView) {
        setNeedsLayout()
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onWillBeginDragging?()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onDidEndDragging?()
    }
}
