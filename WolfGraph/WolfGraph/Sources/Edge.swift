//
//  Edge.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/10/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public struct Edge {
  public typealias ID = Int
  public typealias Func = (Edge) throws -> Void
  public let id: ID
}

extension Edge: Hashable {
  public var hashValue: Int { return id }
  public static func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.id == rhs.id
  }
}
