//
//  Serializer.swift
//  WolfBase
//
//  Created by Wolf McNally on 12/9/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Dispatch

private typealias SerializerKey = DispatchSpecificKey<Int>
private let serializerKey = SerializerKey()
private var nextQueueContext: Int = 1

public class Serializer {
    let queue: DispatchQueue
    let queueContext: Int
    
    public init(label: String? = nil) {
        let label = label ?? String(nextQueueContext)
        queue = DispatchQueue(label: label, attributes: [])
        queueContext = nextQueueContext
        queue.setSpecific(key: serializerKey, value: queueContext)
        nextQueueContext += 1
    }
    
    var isExecutingOnMyQueue: Bool {
        guard let context = DispatchQueue.getSpecific(key: serializerKey) else { return false }
        return context == queueContext
    }
    
    public func dispatch(f: Block) {
        if isExecutingOnMyQueue {
            f()
        } else {
            queue.sync(execute: f)
        }
    }
    
    public func dispatchWithReturn<T>(f: () -> T) -> T {
        var result: T!
        
        if isExecutingOnMyQueue {
            result = f()
        } else {
            queue.sync {
                result = f()
            }
        }
        
        return result!
    }
}
