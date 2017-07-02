//
//  AdapterGraph.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public protocol AdapterGraph: GraphProtocol {
  associatedtype BaseGraph: GraphProtocol

  var graph: BaseGraph { get set }

  init(graph: BaseGraph)
}

extension AdapterGraph where Nodes == BaseGraph.Nodes, Edges == BaseGraph.Edges, NodeValue == BaseGraph.NodeValue, EdgeValue == BaseGraph.EdgeValue {

  public var nodes: Nodes { return graph.nodes }
  public var edges: Edges { return graph.edges }

  public mutating func newNode(value: NodeValue? = nil) -> Node {
    return graph.newNode(value: value)
  }

  public mutating func newEdge(from tail: Node, to head: Node, value: EdgeValue?) -> Edge {
    return graph.newEdge(from: tail, to: head, value: value)
  }

  public mutating func remove(node: Node) { graph.remove(node: node) }

  public mutating func remove(edge: Edge) { graph.remove(edge: edge) }
  public mutating func removeInEdges(of node: Node) { graph.removeInEdges(of: node) }
  public mutating func removeOutEdges(of node: Node) { graph.removeOutEdges(of: node) }
  public mutating func removeEdges(of node: Node) { graph.removeEdges(of: node) }

  public var anyNode: Node? { return graph.anyNode }

  public mutating func set(node: Node, value: NodeValue) { graph.set(node: node, value: value) }
  public mutating func set(edge: Edge, value: EdgeValue) { graph.set(edge: edge, value: value) }

  public mutating func setHead(of edge: Edge, to head: Node) { graph.setHead(of: edge, to: head) }
  public mutating func setTail(of edge: Edge, to tail: Node) { graph.setTail(of: edge, to: tail) }
  public mutating func set(edge: Edge, tail: Node, head: Node) { graph.set(edge: edge, tail: tail, head: head) }

  public func value(of node: Node) -> NodeValue { return graph.value(of: node) }
  public func value(of edge: Edge) -> EdgeValue { return graph.value(of: edge) }

  public func tail(of edge: Edge) -> Node { return graph.tail(of: edge) }
  public func head(of edge: Edge) -> Node { return graph.head(of: edge) }

  public func label(of node: Node) -> String? { return graph.label(of: node) }
  public func label(of edge: Edge) -> String? { return graph.label(of: edge) }

  public func inEdges(of node: Node) -> Edges { return graph.inEdges(of: node) }
  public func outEdges(of node: Node) -> Edges { return graph.outEdges(of: node) }
  public func edges(of node: Node) -> Edges { return graph.edges(of: node) }

  public func edges(from tail: Node, to head: Node) -> Edges { return graph.edges(from: tail, to: head) }
  public func hasEdge(from tail: Node, to head: Node) -> Bool { return graph.hasEdge(from: tail, to: head) }
}
