//
//  DepthFirstSearch.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

extension GraphProtocol where Nodes.Iterator.Element == Node, Edges.Iterator.Element == Edge {
  public func depthFirstSearch<Roots: Sequence>(from roots: Roots, visitor: GraphVisitorProtocol) throws where Roots.Iterator.Element == Node {
    typealias EdgeIterator = Edges.Iterator
    var nodeStates = [Node: NodeState]()

    func depthFirstVisit(from startNode: Node) throws {
      try visitor.start(node: startNode)

      var stack = [(node: Node, sourceEdge: Edge?, remainingEdges: EdgeIterator)]()
      stack.append((startNode, nil, outEdges(of: startNode).makeIterator()))
      nodeStates[startNode] = .working
      try visitor.discover(node: startNode)

      while(!stack.isEmpty) {
        let (node, sourceEdge, remainingEdges) = stack.removeLast()

        if let sourceEdge = sourceEdge {
          try visitor.finish(edge: sourceEdge)
        }

        var currentNode = node
        var currentOutEdges = remainingEdges

        while let currentEdge = currentOutEdges.next() {
          let nextNode = head(of: currentEdge)
          try visitor.visit(edge: currentEdge)
          switch nodeStates[nextNode]! {
          case .new:
            try visitor.tree(edge: currentEdge)
            stack.append((currentNode, currentEdge, currentOutEdges))

            currentNode = nextNode
            nodeStates[currentNode] = .working
            try visitor.discover(node: currentNode)
            currentOutEdges = outEdges(of: currentNode).makeIterator()
          case .working:
            try visitor.back(edge: currentEdge)
            try visitor.finish(edge: currentEdge)
          case .done:
            try visitor.forwardOrCross(edge: currentEdge)
            try visitor.finish(edge: currentEdge)
          }
        }
        nodeStates[currentNode] = .done
        try visitor.finish(node: currentNode)
      }
    }

    for node in nodes {
      try visitor.initialize(node: node)
      nodeStates[node] = .new
    }

    for root in roots {
      guard nodeStates[root]! == .new else { continue }
      try depthFirstVisit(from: root)
    }

    for node in nodes {
      guard nodeStates[node]! == .new else { continue }
      try depthFirstVisit(from: node)
    }
  }

  public func depthFirstSearch(from root: Node, visitor: GraphVisitorProtocol) throws {
    try depthFirstSearch(from: [root], visitor: visitor)
  }

  public func depthFirstSearch(visitor: GraphVisitorProtocol) throws {
    guard let root = anyNode else { return }
    try depthFirstSearch(from: root, visitor: visitor)
  }
}
