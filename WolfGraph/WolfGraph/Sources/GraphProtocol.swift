//
//  GraphProtocol.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfBase

public protocol GraphProtocol {
  associatedtype NodeValue
  associatedtype EdgeValue
  associatedtype Nodes: Sequence
  associatedtype Edges: Sequence
  
  var nodes: Nodes { get }
  var edges: Edges { get }
  
  mutating func newNode(value: NodeValue?) -> Node
  mutating func remove(node: Node)
  
  mutating func set(node: Node, value: NodeValue)
  mutating func set(edge: Edge, value: EdgeValue)
  
  mutating func newEdge(from tail: Node, to head: Node, value: EdgeValue?) -> Edge
  mutating func remove(edge: Edge)
  mutating func setHead(of edge: Edge, to head: Node)
  mutating func setTail(of edge: Edge, to tail: Node)
  mutating func set(edge: Edge, tail: Node, head: Node)
  
  mutating func removeInEdges(of node: Node)
  mutating func removeOutEdges(of node: Node)
  mutating func removeEdges(of node: Node)
  
  var anyNode: Node? { get }
  
  func value(of node: Node) -> NodeValue
  func value(of edge: Edge) -> EdgeValue
  
  func tail(of edge: Edge) -> Node
  func head(of edge: Edge) -> Node
  
  func label(of node: Node) -> String?
  func label(of edge: Edge) -> String?
  
  func inEdges(of node: Node) -> Edges
  func outEdges(of node: Node) -> Edges
  func edges(of node: Node) -> Edges
  
  func successors(of node: Node) -> Nodes
  func predecessors(of node: Node) -> Nodes
  
  func isParallel(edge edge1: Edge, to edge2: Edge) -> Bool
  func isReverse(edge edge1: Edge, of edge2: Edge) -> Bool
  
  func edges(from tail: Node, to head: Node) -> Edges
  func hasEdge(from tail: Node, to head: Node) -> Bool
}

extension GraphProtocol where Nodes.Iterator.Element == Node, Edges.Iterator.Element == Edge {
  public func printGraph() {
    for node in nodes {
      let outJoiner = Joiner(left: "(", right: ")")
      for edge in outEdges(of: node) {
        outJoiner.append(edge.id)
      }
      
      let inJoiner = Joiner(left: "(", right: ")")
      for edge in inEdges(of: node) {
        inJoiner.append(edge.id)
      }
      
      let succJoiner = Joiner(left: "(", right: ")")
      for node in successors(of: node) {
        succJoiner.append(node.id)
      }
      
      let predJoiner = Joiner(left: "(", right: ")")
      for node in predecessors(of: node) {
        predJoiner.append(node.id)
      }
      
      let lineJoiner = Joiner()
      lineJoiner.append("id: \(node.id)")
      lineJoiner.append("(\(value(of: node)†))")
      if !outJoiner.isEmpty {
        lineJoiner.append("out: \(outJoiner.description)")
      }
      if !inJoiner.isEmpty {
        lineJoiner.append("in: \(inJoiner.description)")
      }
      if !succJoiner.isEmpty {
        lineJoiner.append("succ: \(succJoiner.description)")
      }
      if !predJoiner.isEmpty {
        lineJoiner.append("pred: \(predJoiner.description)")
      }
      print(lineJoiner.description)
    }
    for edge in edges {
      print("id: \(edge.id) (\(value(of: edge)†)) (\(tail(of: edge).id) -> \(head(of: edge).id))")
    }
  }
  
  public func dotFormat() -> String {
    func attributes(with dict: [String: Any]?) -> String {
      guard let dict = dict, dict.count > 0 else { return "" }
      let joiner = Joiner(left: " [", separator: ",", right: "]")
      for (key, value) in dict {
        joiner.append("\(key)=\"\(value)\"")
      }
      return joiner.description
    }
    
    var lines = [String]()
    lines.append("digraph {")
    for node in nodes {
      var attrDict = [String: Any]()
      if let label = label(of: node), !label.isEmpty {
        attrDict["label"] = label
      }
      lines.append("\(node.id)\(attributes(with: attrDict))".indented())
    }
    for edge in edges {
      var attrDict = [String: Any]()
      if let label = label(of: edge), !label.isEmpty {
        attrDict["label"] = label
      }
      lines.append("\(tail(of: edge).id) -> \(head(of: edge).id)\(attributes(with: attrDict))".indented())
    }
    lines.append("}")
    return lines.joined(separator: "\n")
  }
  
  public func successors(of node: Node) -> Nodes {
    return AnySequence<Node>(outEdges(of: node).lazy.map { self.head(of: $0) }) as! Nodes
  }
  
  public func predecessors(of node: Node) -> Nodes {
    return AnySequence<Node>(inEdges(of: node).lazy.map { self.tail(of: $0) }) as! Nodes
  }
  
  public func edges(of node: Node) -> Edges {
    return AnySequence<Edge>([inEdges(of: node), outEdges(of: node)].joined()) as! Edges
  }
  
  public mutating func removeInEdges(of node: Node) {
    for edge in inEdges(of: node) {
      remove(edge: edge)
    }
  }
  
  public mutating func removeOutEdges(of node: Node) {
    for edge in outEdges(of: node) {
      remove(edge: edge)
    }
  }
  
  public mutating func removeEdges(of node: Node) {
    for edge in edges(of: node) {
      remove(edge: edge)
    }
  }
  
  public var anyNode: Node? {
    var nodesIter = nodes.makeIterator()
    let node = nodesIter.next()
    return node
  }
}

extension GraphProtocol {
  public func reversed() -> ReversedGraph<Self> {
    return ReversedGraph(graph: self)
  }
}

extension GraphProtocol {
  public func isParallel(edge edge1: Edge, to edge2: Edge) -> Bool {
    guard edge1 != edge2 else { return true }
    return tail(of: edge1) == tail(of: edge2) && head(of: edge1) == head(of: edge2)
  }
  
  public func isReverse(edge edge1: Edge, of edge2: Edge) -> Bool {
    guard edge1 != edge2 else { return false }
    return tail(of: edge1) == head(of: edge2) && head(of: edge1) == tail(of: edge2)
  }
}
