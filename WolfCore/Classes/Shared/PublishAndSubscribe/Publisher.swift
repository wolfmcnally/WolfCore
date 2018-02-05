//
//  Publisher.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public protocol PublisherProtocol: Hashable {
    associatedtype PublishableType: Publishable
    associatedtype SubscriberType
    
    func publish(_ item: PublishableType)
    func unpublish(_ item: PublishableType)
}

public class Publisher<T: Publishable>: PublisherProtocol {
    public typealias `Self` = Publisher<T>
    public typealias PublishableType = T
    public typealias SubscriberType = Subscriber<PublishableType>
    
    private let id = UUID()
    private var publishedItems = Set<PublishableType>()
    private var subscribers = WeakSet<SubscriberType>()
    
    public init() {
    }
    
    public func publish(_ item: PublishableType) {
        guard case (true, _) = publishedItems.insert(item) else { return }
        for subscriber in subscribers {
            subscriber.addPublishable(item)
        }
        guard let duration = item.duration else { return }
        dispatchOnMain(afterDelay: duration) { [weak self] in
            self?.unpublish(item)
        }
    }
    
    public func unpublish(_ item: PublishableType) {
        guard publishedItems.remove(item) != nil else { return }
        for subscriber in subscribers {
            subscriber.removePublishable(item)
        }
    }
    
    func addSubscriber(_ subscriber: SubscriberType) {
        guard case (true, _) = subscribers.insert(subscriber) else { return }
        for item in publishedItems {
            subscriber.addPublishable(item)
        }
    }
    
    func removeSubscriber(_ subscriber: SubscriberType) {
        guard subscribers.remove(subscriber) != nil else { return }
        for item in publishedItems {
            subscriber.removePublishable(item)
        }
    }
    
    private func removeAllSubscribers() {
        for subscriber in subscribers {
            removeSubscriber(subscriber)
        }
    }
    
    deinit {
        removeAllSubscribers()
    }
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
