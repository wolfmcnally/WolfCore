//
//  ReversedGraph.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public struct ReversedGraph<G: GraphProtocol>: AdapterGraph {
  public typealias BaseGraph = G
  public typealias NodeValue = BaseGraph.NodeValue
  public typealias EdgeValue = BaseGraph.EdgeValue
  public typealias Nodes = BaseGraph.Nodes
  public typealias Edges = BaseGraph.Edges
  
  public var graph: BaseGraph
  
  public init(graph: BaseGraph) {
    self.graph = graph
  }
  
  public mutating func newEdge(from tail: Node, to head: Node, value: EdgeValue?) -> Edge {
    return graph.newEdge(from: head, to: tail, value: value)
  }
  
  public mutating func removeInEdges(of node: Node) { graph.removeOutEdges(of: node) }
  public mutating func removeOutEdges(of node: Node) { graph.removeInEdges(of: node) }
  
  public func tail(of edge: Edge) -> Node { return graph.head(of: edge) }
  public func head(of edge: Edge) -> Node { return graph.tail(of: edge) }
  
  public func inEdges(of node: Node) -> Edges { return graph.outEdges(of: node) }
  public func outEdges(of node: Node) -> Edges { return graph.inEdges(of: node) }
  
  public func successors(of node: Node) -> Nodes { return graph.predecessors(of: node) }
  public func predecessors(of node: Node) -> Nodes { return graph.successors(of: node) }
}
