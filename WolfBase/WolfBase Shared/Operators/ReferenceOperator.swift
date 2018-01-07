//
//  ReferenceOperator.swift
//  WolfBase
//
//  Created by Wolf McNally on 6/29/16.
//  Copyright © 2016 WolfMcNally.com. All rights reserved.
//

public protocol Reference {
    associatedtype ReferentType
    
    var referent: ReferentType { get }
}

///
/// Reference-Operator
///
/// The special character here ("®") is called the "registered trademark symbol" and is typed by pressing Option-R.
///
postfix operator ®

public postfix func ® <T: Reference>(rhs: T) -> T.ReferentType {
    return rhs.referent
}

