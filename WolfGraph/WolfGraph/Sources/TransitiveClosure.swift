//
//  TransitiveClosure.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/17/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

extension GraphProtocol where Nodes.Iterator.Element == Node, Edges.Iterator.Element == Edge {
  public func transitiveClosure() -> Self {
    var g = self
    for k in g.nodes {
      for i in g.nodes {
        if g.hasEdge(from: i, to: k) {
          for j in g.nodes {
            if !g.hasEdge(from: i, to: j) && g.hasEdge(from: k, to: j) {
              _ = g.newEdge(from: i, to: j, value: nil)
            }
          }
        }
      }
    }
    return g
  }
}
