//
//  Position.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/28/16.
//  Copyright © 2016 WolfMcNally.com.
//

public struct Position {
    public var column: Int
    public var row: Int

    public init(column: Int = 0, row: Int = 0) {
        self.column = column
        self.row = row
    }
}
