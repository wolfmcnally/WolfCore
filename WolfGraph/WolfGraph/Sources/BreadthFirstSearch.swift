//
//  BreadthFirstSearch.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

enum NodeState {
  case new
  case working
  case done
}

extension GraphProtocol where Nodes.Iterator.Element == Node, Edges.Iterator.Element == Edge {
  public func breadthFirstSearch<Roots: Sequence>(from roots: Roots, visitor: GraphVisitorProtocol) throws where Roots.Iterator.Element == Node {
    var queue = [Node]()
    var nodeStates = [Node: NodeState]()
    
    for node in nodes {
      try visitor.initialize(node: node)
      nodeStates[node] = .new
    }
    
    for root in roots {
      queue.append(root)
      nodeStates[root] = .working
      try visitor.discover(node: root)
    }
    
    while(!queue.isEmpty) {
      let node = queue.removeFirst()
      try visitor.visit(node: node)
      for edge in outEdges(of: node) {
        let successor = head(of: edge)
        try visitor.visit(edge: edge)
        switch nodeStates[successor]! {
        case .new:
          try visitor.tree(edge: edge)
          nodeStates[node] = .working
          try visitor.discover(node: successor)
          queue.append(successor)
        case .working:
          try visitor.nonTree(edge: edge)
          try visitor.workingHead(edge: edge)
        case .done:
          try visitor.nonTree(edge: edge)
          try visitor.doneHead(edge: edge)
        }
      }
      nodeStates[node] = .done
      try visitor.finish(node: node)
    }
  }
  
  public func breadthFirstSearch(from root: Node, visitor: GraphVisitorProtocol) throws {
    try breadthFirstSearch(from: [root], visitor: visitor)
  }
}
