//
//  Node.swift
//  WolfGraph
//
//  Created by Wolf McNally on 1/10/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

public struct Node {
  public typealias ID = Int
  public typealias Func = (Node) throws -> Void
  public let id: ID
}

extension Node: Hashable {
  public var hashValue: Int { return id }
  public static func ==(lhs: Node, rhs: Node) -> Bool {
    return lhs.id == rhs.id
  }
}
