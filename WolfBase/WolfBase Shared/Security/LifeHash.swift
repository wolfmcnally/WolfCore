//
//  LifeHash.swift
//  WolfBase
//
//  Created by Wolf McNally on 1/20/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public class LifeHash {
    struct Cell {
        var alive: Bool = false
    }
    
    class CellGrid: Grid<Cell> {
        func countNeighbors(_ g: IntPoint) -> Int {
            var count = 0
            forNeighborhood(at: g) { (o, p) in
                guard o != .zero else { return }
                if self[p].alive {
                    count += 1
                }
            }
            return count
        }
        
        static func isAliveInNextGeneration(_ currentAlive: Bool, neighborsCount: Int) -> Bool {
            if currentAlive {
                return neighborsCount == 2 || neighborsCount == 3
            } else {
                return neighborsCount == 3
            }
        }
        
        func nextGeneration(currentChangeGrid: ChangeGrid, nextCellGrid: CellGrid, nextChangeGrid: ChangeGrid) {
            forAll { p in
                if currentChangeGrid[p].changed {
                    let currentAlive = self[p].alive
                    let neighborsCount = self.countNeighbors(p)
                    let nextAlive = CellGrid.isAliveInNextGeneration(currentAlive, neighborsCount: neighborsCount)
                    if nextAlive {
                        nextCellGrid[p] = true
                    }
                    if currentAlive != nextAlive {
                        nextChangeGrid.setChanged(p)
                    }
                }
            }
        }
    }
    
    struct Change {
        var changed: Bool = false
    }
    
    class ChangeGrid: Grid<Change> {
        func setChanged(_ g: IntPoint) {
            forNeighborhood(at: g) { (o, p) in
                self[p] = true
            }
        }
        
        func setAll() {
            setAll(true)
        }
    }
    
    class ColorGrid: Grid<Color> {
        func transformPoint(p: IntPoint, transpose: Bool, reflectX: Bool, reflectY: Bool) -> IntPoint {
            var x = p.x
            var y = p.y
            if transpose {
                swap(&x, &y)
            }
            if reflectX {
                x = maxX - x
            }
            if reflectY {
                y = maxY - y
            }
            return IntPoint(x: x, y: y)
        }
    }
    
    struct Counter {
        var count: Int = 0
    }
    
    class CounterGrid: Grid<Counter> {
        private(set) var maxValue = 0
        
        func add(cellGrid: CellGrid) {
            forAll { p in
                if cellGrid[p].alive {
                    let newValue = self[p].count + 1
                    self[p] = Counter(count: newValue)
                    self.maxValue = max(self.maxValue, newValue)
                }
            }
        }
    }
    
    class FracGrid: Grid<Frac> {
        func setAll(counterGrid: CounterGrid) {
            let maxValue = Double(counterGrid.maxValue)
            forAll { p in
                let count = Double(counterGrid[p].count)
                self[p] = count.lerpedToFrac(from: 0.0..maxValue)
            }
        }
    }
}

extension LifeHash.Cell: CustomStringConvertible {
    var description: String { return alive ? "⚪️" : "⚫️" }
}

extension LifeHash.Cell: Equatable { }

func == (lhs: LifeHash.Cell, rhs: LifeHash.Cell) -> Bool {
    return lhs.alive == rhs.alive
}

extension LifeHash.Cell: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        alive = value
    }
}

extension LifeHash.Change: CustomStringConvertible {
    var description: String { return changed ? "🔴" : "🔵" }
}

extension LifeHash.Change: Equatable { }

func == (lhs: LifeHash.Change, rhs: LifeHash.Change) -> Bool {
    return lhs.changed == rhs.changed
}

extension LifeHash.Change: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        changed = value
    }
}

extension LifeHash.Counter: CustomStringConvertible {
    var description: String { return "\(count)".padded(to: 3) }
}

extension LifeHash.Counter: Equatable { }

func == (lhs: LifeHash.Counter, rhs: LifeHash.Counter) -> Bool {
    return lhs.count == rhs.count
}

func += (lhs: LifeHash.Counter, rhs: Int) -> LifeHash.Counter {
    return LifeHash.Counter(count: lhs.count + rhs)
}
