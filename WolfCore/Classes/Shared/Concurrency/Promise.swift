//
//  Promise.swift
//  WolfCore
//
//  Created by Wolf McNally on 4/26/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import Foundation
import WolfNumerics

public typealias SuccessPromise = Promise<Void>
public typealias DataPromise = Promise<Data>

public class Promise<T>: Cancelable, CustomStringConvertible {
    public typealias `Self` = Promise<T>
    public typealias ValueType = T
    public typealias ResultType = Result<T>
    public typealias RunBlock = (Self) -> Void
    public typealias DoneBlock = (Self) -> Void
    public typealias TaskType = Cancelable

    public var task: TaskType?
    private var onRun: RunBlock!
    private var onDone: DoneBlock!
    public private(set) var result: ResultType?

    public var value: ValueType? {
        switch result {
        case nil:
            return nil
        case .success(let value)?:
            return value
        default:
            fatalError("Invalid value: \(self).")
        }
    }

    public init(task: TaskType? = nil, with onRun: @escaping RunBlock) {
        self.task = task
        self.onRun = onRun
    }

    public convenience init(error: Error) {
        self.init {
            $0.fail(error)
        }
    }

    @discardableResult public func run(with onDone: @escaping DoneBlock) -> Self {
        assert(self.onDone == nil)
        self.onDone = onDone
        onRun(self)
        onRun = { _ in
            fatalError("ran")
        }
        return self
    }

    @discardableResult public func run() -> Self {
        return run { _ in }
    }

    @discardableResult public func map<U>(to uPromise: Promise<U>, with success: @escaping (Promise<U>, ValueType) -> Void) -> Promise<U> {
        run { tPromise in
            switch tPromise.result! {
            case .success(let tValue):
                success(uPromise, tValue)
            case .failure(let error):
                uPromise.fail(error)
            case .aborted:
                uPromise.abort()
            case .canceled:
                uPromise.cancel()
            }
        }
        return uPromise
    }

    @discardableResult public func succeed() -> SuccessPromise {
        return then { (_: ValueType) in }
    }

    public func then<U>(with success: @escaping (ValueType) throws -> U) -> Promise<U> {
        return Promise<U> { (uPromise: Promise<U>) in
            self.map(to: uPromise) { (uPromise2, tValue) in
                do {
                    let uValue = try success(tValue)
                    uPromise2.keep(uValue)
                } catch let error {
                    uPromise2.fail(error)
                }
            }
        }
    }

    public func thenWith<U>(_ success: @escaping (Promise<T>) throws -> U) -> Promise<U> {
        return Promise<U> { (uPromise: Promise<U>) in
            self.map(to: uPromise) { (uPromise2, _) in
                do {
                    let uValue = try success(self)
                    uPromise2.keep(uValue)
                } catch let error {
                    uPromise2.fail(error)
                }
            }
        }
    }

    public func next<U>(with success: @escaping (ValueType) -> Promise<U>) -> Promise<U> {
        return Promise<U> { (uPromise: Promise<U>) in
            self.map(to: uPromise) { (uPromise2, tValue) in
                success(tValue).map(to: uPromise2) { (uPromise3, uValue) in
                    uPromise3.keep(uValue)
                }
            }
        }
    }

    public func `catch`(with failure: @escaping ErrorBlock) -> Promise<T> {
        return Promise<T> { (catchPromise: Promise<T>) in
            self.run { throwPromise in
                switch throwPromise.result! {
                case .success(let value):
                    catchPromise.keep(value)
                case .failure(let error):
                    catchPromise.fail(error)
                    failure(error)
                case .aborted:
                    catchPromise.abort()
                case .canceled:
                    catchPromise.cancel()
                }
            }
        }
    }

    public func recover(with failing: @escaping (Error, Promise<T>) -> Void) -> Promise<T> {
        return Promise<T> { (recoverPromise: Promise<T>) in
            self.run { failingPromise in
                switch failingPromise.result! {
                case .success(let value):
                    recoverPromise.keep(value)
                case .failure(let error):
                    failing(error, recoverPromise)
                case .aborted:
                    recoverPromise.abort()
                case .canceled:
                    recoverPromise.cancel()
                }
            }
        }
    }

    public func finally(with block: @escaping Block) -> Promise<T> {
        return Promise<T> { (finallyPromise: Promise<T>) in
            self.run { finishedPromise in
                switch finishedPromise.result! {
                case .success(let value):
                    finallyPromise.keep(value)
                    block()
                case .failure(let error):
                    finallyPromise.fail(error)
                    block()
                case .aborted:
                    finallyPromise.abort()
                    block()
                case .canceled:
                    finallyPromise.cancel()
                }
            }
        }
    }

    private func done() {
        onDone(self)
        onDone = { _ in
            fatalError("done")
        }
        task = nil
    }

    public func keep(_ value: ValueType) {
        guard self.result == nil else { return }

        self.result = ResultType.success(value)
        done()
    }

    public func fail(_ error: Error) {
        guard self.result == nil else { return }

        self.result = ResultType.failure(error)
        done()
    }

    public func abort() {
        guard self.result == nil else { return }

        self.result = ResultType.aborted
        done()
    }

    public func cancel() {
        guard self.result == nil else { return }

        task?.cancel()
        self.result = ResultType.canceled
        done()
    }

    public var isCanceled: Bool {
        return result?.isCanceled ?? false
    }

    public var description: String {
        return "Promise(\(result†))"
    }
}

public func testPromise() {
    typealias IntPromise = Promise<Int>

    func rollDie() -> IntPromise {
        return IntPromise { promise in
            dispatchOnBackground(afterDelay: Random.number(1.0..3.0)) {
                dispatchOnMain {
                    promise.keep(Random.number(1...6))
                }
            }
        }
    }

    func sum(_ a: IntPromise, _ b: IntPromise) -> IntPromise {
        return IntPromise { promise in
            func _sum() {
                if let a = a.value, let b = b.value {
                    promise.keep(a + b)
                }
            }

            a.run {
                print("a: \($0)")
                _sum()
            }

            b.run {
                print("b: \($0)")
                _sum()
            }
        }
    }

    sum(rollDie(), rollDie()).run {
        print("sum: \($0)")
    }
}
