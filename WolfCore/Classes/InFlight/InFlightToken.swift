//
//  InFlightToken.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/26/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public class InFlightToken: Equatable, Hashable, CustomStringConvertible {
    private static var nextID = 1
    public let id: Int
    public let name: String
    public internal(set) var result: ResultSummary?
    #if !os(Linux)
    private var networkActivityRef: LockerCause?
    #endif
    
    init(name: String) {
        id = InFlightToken.nextID
        InFlightToken.nextID += 1
        self.name = name
    }
    
    public var hashValue: Int { return id }
    
    public var description: String {
        return "InFlightToken(id: \(id), name: \(name), result: \(result†))"
    }
    
    public var isNetworkActive: Bool = false {
        didSet {
            #if !os(Linux)
                if isNetworkActive {
                    networkActivityRef = networkActivity.newActivity()
                } else {
                    networkActivityRef = nil
                }
            #endif
        }
    }
}

public func == (lhs: InFlightToken, rhs: InFlightToken) -> Bool {
    return lhs.id == rhs.id
}
