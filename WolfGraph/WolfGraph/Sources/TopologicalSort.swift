//
//  TopologicalSort.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/15/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

extension GraphError {
  public static let notDAG = GraphError("notDAG")
}

extension GraphProtocol where Nodes.Iterator.Element == Node, Edges.Iterator.Element == Edge {
  public func topologicalSort() throws -> [Node] {
    var orderedNodes = [Node]()
    var visitor = GraphVisitor()
    visitor.onBackEdge = { _ in throw GraphError.notDAG }
    visitor.onFinishNode = { orderedNodes.insert($0, at: 0) }
    try depthFirstSearch(visitor: visitor)
    return orderedNodes
  }
}
