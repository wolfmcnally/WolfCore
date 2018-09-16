//
//  MessageBulletin.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/29/17.
//  Copyright © 2017 WolfMcNally.com.
//

import Foundation

open class MessageBulletin: Bulletin {
    public let title: String?
    public let message: String?

    public init(title: String? = nil, message: String? = nil, priority: Int = normalPriority, duration: TimeInterval? = nil) {
        self.title = title
        self.message = message
        super.init(priority: priority, duration: duration)
    }
}
