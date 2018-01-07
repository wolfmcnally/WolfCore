//
//  Runes.swift
//  WolfBase
//
//  Created by Wolf McNally on 7/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

//    https://github.com/thoughtbot/Runes

//    Copyright (c) 2014 thoughtbot, inc.
//
//    MIT License
//
//    Permission is hereby granted, free of charge, to any person obtaining
//    a copy of this software and associated documentation files (the
//    "Software"), to deal in the Software without restriction, including
//    without limitation the rights to use, copy, modify, merge, publish,
//    distribute, sublicense, and/or sell copies of the Software, and to
//    permit persons to whom the Software is furnished to do so, subject to
//    the following conditions:
//
//    The above copyright notice and this permission notice shall be
//    included in all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


//    ## What's included? ##
//
//    Importing Runes introduces several new operators and one global function:
//
//    - `<^>` (pronounced "map")
//    - `<*>` (pronounced "apply")
//    - `>>-` (pronounced "flatMap") (left associative)
//    - `-<<` (pronounced "flatMap") (right associative)
//    - `pure` (pronounced "pure")
//    - `>->` (pronounced "Monadic compose") (left associative)
//    - `<-<` (pronounced "Monadic compose") (right associative)
//
//    We also include default implementations for Optional and Array with the
//    following type signatures:
//
//    ```swift
//    // Optional:
//    public func <^><T, U>(f: T -> U, a: T?) -> U?
//    public func <*><T, U>(f: (T -> U)?, a: T?) -> U?
//    public func >>-<T, U>(a: T?, f: T -> U?) -> U?
//    public func -<<<T, U>(f: T -> U?, a: T?) -> U?
//    public func pure<T>(a: T) -> T?
//    public func >-> <A, B, C>(f: A -> B?, g: B -> C?) -> A -> C?
//    public func <-< <A, B, C>(f: B -> C?, g: A -> B?) -> A -> C?
//
//    // Array:
//    public func <^><T, U>(f: T -> U, a: [T]) -> [U]
//    public func <*><T, U>(fs: [T -> U], a: [T]) -> [U]
//    public func >>-<T, U>(a: [T], f: T -> [U]) -> [U]
//    public func -<<<T, U>(f: T -> [U], a: [T]) -> [U]
//    public func pure<T>(a: T) -> [T]
//    public func >-> <A, B, C>(f: A -> [B], g: B -> [C]) -> A -> [C]
//    public func <-< <A, B, C>(f: B -> [C], g: A -> [B]) -> A -> [C]
//    ```

/**
 map a function over a value with context

 Expected function type: `(a -> b) -> f a -> f b`

 */
infix operator <^> : ComparisonPrecedence

/**
 apply a function with context to a value with context

 Expected function type: `f (a -> b) -> f a -> f b`
 */
infix operator <*> : ComparisonPrecedence

/**
 map a function over a value with context and flatten the result

 Expected function type: `m a -> (a -> m b) -> m b`
 */
infix operator >>- : PipeLeftPrecedence

/**
 map a function over a value with context and flatten the result

 Expected function type: `(a -> m b) -> m a -> m b`
 */
infix operator -<< : PipeRightPrecedence

/**
 compose two functions that produce results in a context, from left to right, returning a result in that context

 Expected function type: `(a -> m b) -> (b -> m c) -> a -> m c`
 */
infix operator >-> : PipeLeftPrecedence

/**
 compose two functions that produce results in a context, from right to left, returning a result in that context

 like `>->`, but with the arguments flipped

 Expected function type: `(b -> m c) -> (a -> m b) -> a -> m c`
 */
infix operator <-< : PipeRightPrecedence
