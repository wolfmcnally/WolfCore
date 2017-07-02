//
//  Graph.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/10/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

struct TailHead: Hashable {
  public let tail: Node
  public let head: Node
  
  public var hashValue: Int {
    return tail.hashValue + head.hashValue
  }
  
  public static func ==(lhs: TailHead, rhs: TailHead) -> Bool {
    return lhs.tail == rhs.tail && lhs.head == rhs.head
  }
}

public struct Graph<NodeValue, EdgeValue>: GraphProtocol {
  public typealias NodeValues = [Node: NodeValue]
  public typealias EdgeValues = [Edge: EdgeValue]
  
  public typealias Nodes = AnySequence<Node>
  public typealias Edges = AnySequence<Edge>
  typealias NodeEdges = [Node: Set<Edge>]
  typealias EdgeTailHeads = [Edge: TailHead]
  typealias TailHeadEdges = [TailHead: Set<Edge>]
  
  var label: String
  var defaultNodeValue: NodeValue
  var defaultEdgeValue: EdgeValue
  var lastID: Int = 0
  var nodeValues = NodeValues()
  var edgeValues = EdgeValues()
  var edgeTailHeads = EdgeTailHeads()
  var tailHeadEdges = TailHeadEdges()
  var nodeInEdges = NodeEdges()
  var nodeOutEdges = NodeEdges()
  
  mutating func add(edge: Edge, for tailHead: TailHead) {
    var e = tailHeadEdges[tailHead] ?? Set<Edge>()
    e.insert(edge)
    tailHeadEdges[tailHead] = e
  }
  
  mutating func remove(edge: Edge, for tailHead: TailHead) {
    guard var e = tailHeadEdges[tailHead] else { return }
    e.remove(edge)
    tailHeadEdges[tailHead] = e.isEmpty ? nil : e
  }
  
  public var nodes: Nodes {
    return AnySequence(nodeValues.lazy.map { return $0.0 })
  }
  
  public var edges: Edges {
    return AnySequence(edgeValues.lazy.map { return $0.0 })
  }
  
  init(label: String, defaultNodeValue: NodeValue, defaultEdgeValue: EdgeValue) {
    self.label = label
    self.defaultNodeValue = defaultNodeValue
    self.defaultEdgeValue = defaultEdgeValue
  }
  
  private mutating func nextID() -> Int {
    lastID += 1; return lastID
  }
  
  public mutating func newNode(value: NodeValue? = nil) -> Node {
    let value = value ?? defaultNodeValue
    let node = Node(id: nextID())
    nodeValues[node] = value
    return node
  }
  
  private func insert(edge: Edge, of node: Node, into nodeEdges: inout NodeEdges) {
    var edges = nodeEdges[node] ?? Set<Edge>()
    edges.insert(edge)
    nodeEdges[node] = edges
  }
  
  public mutating func newEdge(from tail: Node, to head: Node, value: EdgeValue? = nil) -> Edge {
    let value = value ?? defaultEdgeValue
    let edge = Edge(id: nextID())
    edgeValues[edge] = value
    let tailHead = TailHead(tail: tail, head: head)
    edgeTailHeads[edge] = tailHead
    add(edge: edge, for: tailHead)
    insert(edge: edge, of: tail, into: &nodeOutEdges)
    insert(edge: edge, of: head, into: &nodeInEdges)
    return edge
  }
  
  public mutating func remove(edge: Edge) {
    nodeOutEdges[tail(of: edge)] = nil
    nodeInEdges[head(of: edge)] = nil
    edgeValues[edge] = nil
    let tailHead = edgeTailHeads[edge]!
    remove(edge: edge, for: tailHead)
    edgeTailHeads[edge] = nil
  }
  
  public mutating func remove(node: Node) {
    removeEdges(of: node)
    nodeValues[node] = nil
  }
  
  public mutating func setHead(of edge: Edge, to head: Node) {
    let old = edgeTailHeads[edge]!
    guard old.head != head else { return }
    let new = TailHead(tail: old.tail, head: head)
    edgeTailHeads[edge] = new
    remove(edge: edge, for: old)
    add(edge: edge, for: new)
  }
  
  public mutating func setTail(of edge: Edge, to tail: Node) {
    let old = edgeTailHeads[edge]!
    guard old.tail != tail else { return }
    let new = TailHead(tail: tail, head: old.head)
    edgeTailHeads[edge] = new
    remove(edge: edge, for: old)
    add(edge: edge, for: new)
  }
  
  public mutating func set(edge: Edge, tail: Node, head: Node) {
    let old = edgeTailHeads[edge]!
    guard old.tail != tail || old.head != head else { return }
    let new = TailHead(tail: tail, head: head)
    edgeTailHeads[edge] = new
    remove(edge: edge, for: old)
    add(edge: edge, for: new)
  }
  
  public mutating func set(node: Node, value: NodeValue) {
    nodeValues[node] = value
  }
  
  public mutating func set(edge: Edge, value: EdgeValue) {
    edgeValues[edge] = value
  }
  
  public func value(of node: Node) -> NodeValue {
    return nodeValues[node]!
  }
  
  public func value(of edge: Edge) -> EdgeValue {
    return edgeValues[edge]!
  }
  
  public func tail(of edge: Edge) -> Node {
    return edgeTailHeads[edge]!.tail
  }
  
  public func head(of edge: Edge) -> Node {
    return edgeTailHeads[edge]!.head
  }
  
  public func label(of node: Node) -> String? {
    return value(of: node) as? String
  }
  
  public func label(of edge: Edge) -> String? {
    return value(of: edge) as? String
  }
  
  public func inEdges(of node: Node) -> Edges {
    return AnySequence<Edge>((nodeInEdges[node] ?? Set<Edge>()).lazy)
  }
  
  public func outEdges(of node: Node) -> Edges {
    return AnySequence<Edge>((nodeOutEdges[node] ?? Set<Edge>()).lazy)
  }
  
  public func edges(from tail: Node, to head: Node) -> Edges {
    let e = tailHeadEdges[TailHead(tail: tail, head: head)] ?? Set<Edge>()
    return AnySequence<Edge>(e)
  }
  
  public func hasEdge(from tail: Node, to head: Node) -> Bool {
    return edges(from: tail, to: head).makeIterator().next() != nil
  }
}

@discardableResult public func += <N, E>(lhs: inout Graph<N, E>, rhs: (Node, Node)) -> Edge {
  return lhs.newEdge(from: rhs.0, to: rhs.1)
}

@discardableResult public func += <N, E>(lhs: inout Graph<N, E>, rhs: (Node, Node, E)) -> Edge {
  return lhs.newEdge(from: rhs.0, to: rhs.1, value: rhs.2)
}

@discardableResult public func += <N, E>(lhs: inout Graph<N, E>, rhs: Graph<N, E>.NodeValue) -> Node {
  return lhs.newNode(value: rhs)
}

@discardableResult public func += <N, E>(graph: inout Graph<N, E>, rhs: (Node, [Node])) -> [Edge] {
  var edges = [Edge]()
  let (tail, heads) = rhs
  for head in heads {
    edges.append(graph += (tail, head))
  }
  return edges
}


extension Graph: CustomStringConvertible {
  public var description: String {
    return "\(Graph.self)(label: \"\(label)\")"
  }
}
