//
//  Heartbeat.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/15/15.
//  Copyright © 2015 WolfMcNally.com. All rights reserved.
//

import Foundation

// To send heartbeats:
//
// After a connection, instantiate a Heartbeat object and call reset().
// After a disconnect, call cancel() or destroy the Heartbeat object.
// Every time you send a non-heartbeat packet, call reset().
// When expired() is called, send a heartbeat packet and call reset().

// To listen for heartbeats:
//
// After a connection, instantiate a Heartbeat object and call reset().
// After a disconnect, call cancel() or destroy the Heartbeat object.
// The interval of a listener Heartbeat should be longer than the interval of the sender Heartbeat to allow for latency.
// Every time you receive a packet, call reset().
// When expired() is called, you've lost the heartbeat, so disconnect. If you're the client, attempt to reconnect.

public class Heartbeat {
    public var interval: TimeInterval
    public var expired: Block
    private var canceler: Cancelable?

    public init(interval: TimeInterval, expired: @escaping Block) {
        self.interval = interval
        self.expired = expired
    }

    deinit {
        cancel()
    }

    public func cancel() {
        canceler?.cancel()
        canceler = nil
    }

    public func reset() {
        cancel()
        canceler = dispatchOnMain(afterDelay: interval) { [unowned self] in
            self.expired()
        }
    }
}
