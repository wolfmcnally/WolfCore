//
//  JSONModel.swift
//  WolfBase
//
//  Created by Wolf McNally on 3/31/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

public protocol JSONModel: CustomStringConvertible, JSONRepresentable {
    init(json: JSON)
}

extension JSONModel {
    public var description: String {
        return json.prettyString
    }
}
