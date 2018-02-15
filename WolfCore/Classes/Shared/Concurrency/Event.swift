//
//  Event.swift
//  WolfCore
//
//  Created by Wolf McNally on 11/15/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation

public class Event<T> {
    public typealias ValueType = T
    private var observers = Set<Observer>()

    public init() { }

    public class Observer: Hashable, Invalidatable {
        public typealias FuncType = (ValueType) -> Void
        private let id = UUID()
        public let closure: FuncType
        weak var event: Event?

        public init(event: Event, closure: @escaping FuncType) {
            self.event = event
            self.closure = closure
        }

        public var hashValue: Int {
            return id.hashValue
        }

        public static func == (lhs: Observer, rhs: Observer) -> Bool {
            return lhs.id == rhs.id
        }

        public func invalidate() {
            event?.remove(observer: self)
        }

        deinit {
            invalidate()
        }
    }

    public func add(observerFunc: @escaping Observer.FuncType) -> Observer {
        let observer = Observer(event: self, closure: observerFunc)
        observers.insert(observer)
        return observer
    }

    public func remove(observer: Observer?) {
        guard let observer = observer else { return }
        observers.remove(observer)
    }

    public func notify(_ value: ValueType) {
        for observer in observers {
            observer.closure(value)
        }
    }

    public var isEmpty: Bool {
        return observers.isEmpty
    }
}
