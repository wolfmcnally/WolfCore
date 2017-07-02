//
//  StronglyConnectedComponents.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/17/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

extension GraphProtocol where Nodes.Iterator.Element == Node, Edges.Iterator.Element == Edge {
  public typealias ComponentIndex = Int
  public func strongComponents() throws -> [Node: ComponentIndex] {
    var nodeComponents = [Node: ComponentIndex]()
    var nodeRoots = [Node: Node]()
    var nodeDiscoverTimes = [Node: Int]()
    var stack = [Node]()
    var discoveryTime = 0
    var componentIndex = 0
    
    var visitor = GraphVisitor()
    
    visitor.onDiscoverNode = { node in
      defer { discoveryTime += 1 }
      nodeRoots[node] = node
      nodeDiscoverTimes[node] = discoveryTime
      stack.append(node)
    }
    
    func nodeWithMinDiscoveryTime(_ u: Node, _ v: Node) -> Node {
      return nodeDiscoverTimes[u]! < nodeDiscoverTimes[v]! ? u : v
    }
    
    visitor.onFinishNode = { node in
      for succ in self.successors(of: node) {
        guard nodeComponents[succ] == nil else { continue }
        nodeRoots[node] = nodeWithMinDiscoveryTime(nodeRoots[node]!, nodeRoots[succ]!)
      }
      if nodeRoots[node]! == node {
        defer { componentIndex += 1 }
        var w: Node
        repeat {
          w = stack.removeLast()
          nodeComponents[w] = componentIndex
          nodeRoots[w] = node
        } while(w != node)
      }
    }
    
    try depthFirstSearch(visitor: visitor)
    
    return nodeComponents
  }
}
