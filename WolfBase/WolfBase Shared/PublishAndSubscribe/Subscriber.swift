//
//  Subscriber.swift
//  WolfBase
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol SubscriberProtocol: Hashable {
    associatedtype PublishableType
    associatedtype PublisherType
    
    func subscribe(to publisher: PublisherType)
    func unsubscribe(from publisher: PublisherType)
}

public class Subscriber<T: Publishable>: SubscriberProtocol {
    public typealias `Self` = Subscriber<T>
    public typealias PublishableType = T
    public typealias PublisherType = Publisher<PublishableType>
    
    private let id = UUID()
    private private(set) var subscribedItems = Set<PublishableType>()
    private var publishers = WeakSet<PublisherType>()
    
    public typealias ItemBlock = (PublishableType) -> Void
    public var onAddedItem: ItemBlock?
    public var onRemovedItem: ItemBlock?
    
    public init() {
    }
    
    func addPublishable(_ item: PublishableType) {
        guard case (true, _) = subscribedItems.insert(item) else { return }
        onAddedItem?(item)
    }
    
    func removePublishable(_ item: PublishableType) {
        guard subscribedItems.remove(item) != nil else { return }
        onRemovedItem?(item)
    }
    
    public func subscribe(to publisher: PublisherType) {
        guard case (true, _) = publishers.insert(publisher) else { return }
        publisher.addSubscriber(self)
    }
    
    public func unsubscribe(from publisher: PublisherType) {
        guard publishers.remove(publisher) != nil else { return }
        publisher.removeSubscriber(self)
    }
    
    private func removeAllPublishers() {
        for publisher in publishers {
            unsubscribe(from: publisher)
        }
    }
    
    deinit {
        removeAllPublishers()
    }
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
