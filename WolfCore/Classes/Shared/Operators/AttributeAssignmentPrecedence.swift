//
//  AttributeAssignmentPrecedence.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/24/17.
//  Copyright © 2017 WolfMcNally.com.
//

precedencegroup AttributeAssignmentPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}
