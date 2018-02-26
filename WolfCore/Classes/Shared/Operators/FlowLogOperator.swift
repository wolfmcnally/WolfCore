//
//  FlowLogOperator.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/25/18.
//

///
/// Flow-Log-Operator
///
/// The special character here ("©") is called the "copyright symbol" and is typed by pressing Option-G.
///

infix operator ¿ :  AssignmentPrecedence

/// The purpose of the FlogLog operator is to print the result of an expression and the return it without requiring it be broken out as a separate variable with a separate identifier and sent to print().
/// This is useful when debugging code and wanting to see a labeled value in the log as it is generated, without having to restructure the code.
/// Once the bug is found, the label and FlowLog operator are simply removed, and the rest of the code functions the same.
public func ¿ <T> (label: String, value: T) -> T {
    print("¿ \(label): \(value)")
    return value
}

// Example:
//
//    func add(a: Int, b: Int) -> Int {
//        return a + b
//    }
//
//    func addAndLog(a: Int, b: Int) -> Int {
//        return "result" ¿ a + b
//    }
//
// print(add(a: 1, b: 2))
// 3
//
// addAndLog(a: 1, b: 2)
// ¿ result: 3
