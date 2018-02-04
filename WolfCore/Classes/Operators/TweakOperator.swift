//
//  TweakOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/16/18.
//  Copyright © 2018 WolfMcNally.com. All rights reserved.
//

///
/// Tweak-Operator
///
/// The special character here ("‡") is called the "double dagger" and is typed by pressing Option-Shift-7.
///
prefix operator ‡

///
/// Note that all uses of the Tweak-Operator SHOULD be idempotent.
/// i.e.:
///     let a = A()
///     ‡a          // a MAY have changed state
///     ‡a          // a SHOULD NOT have changed state
///
