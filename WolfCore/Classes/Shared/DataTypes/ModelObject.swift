//
//  ModelObject.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/21/17.
//  Copyright © 2017 WolfMcNally.com.
//

public protocol ModelObject {
    associatedtype Model

    var model: Model! { get set }

    func syncToModel()
}
