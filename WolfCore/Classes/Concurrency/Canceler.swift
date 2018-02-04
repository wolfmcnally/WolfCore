//
//  Canceler.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/17/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public protocol Cancelable: class {
    var isCanceled: Bool { get }
    func cancel()
}

// A block that takes a Canceler. The block will not be called again if it sets the <isCanceled> variable of the Canceler to true.
public typealias CancelableBlock = (Cancelable) -> Void

// A Canceler is returned by that either execute a block asyncronously once or at intervals. If the <isCanceled> variable is set to true, the block will never be executed, or the calling of the block at intervals will stop.
public class Canceler: Cancelable {
    public init() { }
    public var isCanceled = false
    public func cancel() { isCanceled = true }
}
