//
//  Matrix.swift
//  WolfBase
//
//  Created by Wolf McNally on 2/23/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public class Matrix<T> {
    public typealias ValueType = T
    typealias RowType = [ValueType?]
    private var rows = [RowType]()
    public private(set) var columnsCount: Int = 0
    public var rowsCount: Int {
        return rows.count
    }
    
    public init() { }
    
    public func removeAll() {
        rows = [RowType]()
        columnsCount = 0
    }
    
    public func object(atPosition position: Position) -> ValueType? {
        guard position.row < rowsCount else {
            return nil
        }
        
        let row = rows[position.row]
        guard position.column < row.count else {
            return nil
        }
        
        return row[position.column]
    }
    
    public func set(object value: ValueType?, atPosition position: Position) {
        while rowsCount <= position.row {
            rows.append(RowType())
        }
        
        while rows[position.row].count <= position.column {
            rows[position.row].append(nil)
            if rows[position.row].count > columnsCount {
                columnsCount = rows[position.row].count
            }
        }
        
        rows[position.row][position.column] = value
    }
    
    public func compact() {
        columnsCount = 0
        var removingRows = true
        
        for rowIndex in (0..<rowsCount).reversed() {
            let originalColumnsCount = rows[rowIndex].count
            var newColumnsCount = originalColumnsCount
            for columnIndex in (0..<originalColumnsCount).reversed() {
                if rows[rowIndex][columnIndex] == nil {
                    rows[rowIndex].removeLast()
                    newColumnsCount -= 1
                } else {
                    break
                }
            }
            
            if newColumnsCount > columnsCount {
                columnsCount = newColumnsCount
            }
            
            if removingRows {
                if newColumnsCount == 0 {
                    rows.removeLast()
                } else {
                    removingRows = false
                }
            }
        }
    }
}
