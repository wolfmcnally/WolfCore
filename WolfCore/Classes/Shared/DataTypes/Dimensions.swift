//
//  Dimensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/13/17.
//  Copyright © 2017 WolfMcNally.com.
//

public struct Dimensions: Sequence {
    public let columns: Int
    public let rows: Int
    public let columnMajor: Bool

    public func makeIterator() -> Iterator {
        return Iterator(self)
    }

    public struct Iterator: IteratorProtocol {
        let dimensions: Dimensions
        var current: Position! = Position()

        public init(_ dimensions: Dimensions) {
            self.dimensions = dimensions
        }

        public mutating func next() -> Position? {
            guard current != nil else { return nil }

            let n = current

            if dimensions.columnMajor {
                if current.row == dimensions.rows - 1 {
                    if current.column == dimensions.columns - 1 {
                        current = nil
                    } else {
                        current.row = 0; current.column += 1
                    }
                } else {
                    current.row += 1
                }
            } else {
                if current.column == dimensions.columns - 1 {
                    if current.row == dimensions.rows - 1 {
                        current = nil
                    } else {
                        current.column = 0; current.row += 1
                    }
                } else {
                    current.column += 1
                }
            }

            return n
        }
    }

    public init(columns: Int, rows: Int, columnMajor: Bool = false) {
        self.columns = columns
        self.rows = rows
        self.columnMajor = columnMajor
    }

    public var columnsRange: AnySequence<Int> {
        return AnySequence<Int>(0 ..< columns)
    }

    public var rowsRange: AnySequence<Int> {
        return AnySequence<Int>(0 ..< rows)
    }
}
