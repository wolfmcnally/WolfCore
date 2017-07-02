//
//  GraphVisitor.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import WolfBase

public protocol GraphVisitorProtocol {
  func initialize(node: Node) throws
  func discover(node: Node) throws
  func visit(node: Node) throws
  func finish(node: Node) throws
  func visit(edge: Edge) throws
  func tree(edge: Edge) throws
  
  func nonTree(edge: Edge) throws
  func workingHead(edge: Edge) throws
  func doneHead(edge: Edge) throws
  
  func finish(edge: Edge) throws
  func back(edge: Edge) throws
  func forwardOrCross(edge: Edge) throws
  func start(node: Node) throws
}

extension GraphVisitorProtocol {
  // Used by both depth-first search and breadth-first search
  public func initialize(node: Node) { }
  public func discover(node: Node) { }
  public func visit(node: Node) { }
  public func finish(node: Node) { }
  
  // Used only by breadth-first search
  public func visit(edge: Edge) { }
  public func tree(edge: Edge) { }
  public func nonTree(edge: Edge) { }
  public func workingHead(edge: Edge) { }
  public func doneHead(edge: Edge) { }
  
  // Used only by depth-first search
  public func finish(edge: Edge) { }
  public func back(edge: Edge) { }
  public func forwardOrCross(edge: Edge) { }
  public func start(node: Node) { }
}

public struct LoggingGraphVisitor<G: GraphProtocol>: GraphVisitorProtocol {
  public typealias GraphType = G
  
  let graph: GraphType
  
  public init (graph: GraphType) {
    self.graph = graph
  }
  
  public func initialize(node: Node) { logInfo("initialize: \(graph.label(of: node)†)") }
  public func discover(node: Node) { logInfo("discover: \(graph.label(of: node)†)") }
  public func visit(node: Node) { logInfo("visit: \(graph.label(of: node)†)") }
  public func finish(node: Node) { logInfo("finish: \(graph.label(of: node)†)") }
  
  public func visit(edge: Edge) { logInfo("visit: \(graph.label(of: edge)†)") }
  public func tree(edge: Edge) { logInfo("tree: \(graph.label(of: edge)†)") }
  public func nonTree(edge: Edge) { logInfo("nonTree: \(graph.label(of: edge)†)") }
  public func workingHead(edge: Edge) { logInfo("workingHead: \(graph.label(of: edge)†)") }
  public func doneHead(edge: Edge) { logInfo("doneHead: \(graph.label(of: edge)†)") }
  
  public func finish(edge: Edge) { logInfo("finish: \(graph.label(of: edge)†)") }
  public func back(edge: Edge) { logInfo("back: \(graph.label(of: edge)†)") }
  public func forwardOrCross(edge: Edge) { logInfo("forwardOrCross: \(graph.label(of: edge)†)") }
  public func start(node: Node) { logInfo("start: \(graph.label(of: node)†)") }
}

public struct GraphVisitor: GraphVisitorProtocol {
  public var onInitializeNode: Node.Func?
  public var onDiscoverNode: Node.Func?
  public var onExamineNode: Node.Func?
  public var onFinishNode: Node.Func?
  
  public var onVisitEdge: Edge.Func?
  public var onTreeEdge: Edge.Func?
  public var onNonTreeEdge: Edge.Func?
  public var onWorkingHead: Edge.Func?
  public var onDoneHead: Edge.Func?
  
  public var onFinish: Edge.Func?
  public var onBackEdge: Edge.Func?
  public var onForwardOrCross: Edge.Func?
  public var onStart: Node.Func?
  
  public func initialize(node: Node) throws { try onInitializeNode?(node) }
  public func discover(node: Node) throws { try onDiscoverNode?(node) }
  public func visit(node: Node) throws { try onExamineNode?(node) }
  public func finish(node: Node) throws { try onFinishNode?(node) }
  
  public func visit(edge: Edge) throws { try onVisitEdge?(edge) }
  public func tree(edge: Edge) throws { try onTreeEdge?(edge) }
  public func nonTree(edge: Edge) throws { try onNonTreeEdge?(edge) }
  public func workingHead(edge: Edge) throws { try onWorkingHead?(edge) }
  public func doneHead(edge: Edge) throws { try onDoneHead?(edge) }
  
  public func finish(edge: Edge) throws { try onFinish?(edge) }
  public func back(edge: Edge) throws { try onBackEdge?(edge) }
  public func forwardOrCross(edge: Edge) throws { try onForwardOrCross?(edge) }
  public func start(node: Node) throws { try onStart?(node) }
}
