//
//  RunesArray.swift
//  WolfCore
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

/**
 map a function over an array of values
 
 This will return a new array resulting from the transformation function being applied to each value in the array
 
 - parameter f: A transformation function from type `T` to type `U`
 - parameter a: A value of type `[T]`
 
 - returns: A value of type `[U]`
 */
public func <^> <T, U>(f: (T) -> U, a: [T]) -> [U] {
    return a.map(f)
}

/**
 apply an array of functions to an array of values
 
 This will return a new array resulting from the matrix of each function being applied to each value in the array
 
 - parameter fs: An array of transformation functions from type `T` to type `U`
 - parameter a: A value of type `[T]`
 
 - returns: A value of type `[U]`
 */
public func <*> <T, U>(fs: [(T) -> U], a: [T]) -> [U] {
    return a.apply(fs)
}

/**
 flatMap a function over an array of values (left associative)
 
 apply a function to each value of an array and flatten the resulting array
 
 - parameter f: A transformation function from type `T` to type `[U]`
 - parameter a: A value of type `[T]`
 
 - returns: A value of type `[U]`
 */
public func >>- <T, U>(a: [T], f: (T) -> [U]) -> [U] {
    return a.flatMap(f)
}

/**
 flatMap a function over an array of values (right associative)
 
 apply a function to each value of an array and flatten the resulting array
 
 - parameter f: A transformation function from type `T` to type `[U]`
 - parameter a: A value of type `[T]`
 
 - returns: A value of type `[U]`
 */
public func -<< <T, U>(f: (T) -> [U], a: [T]) -> [U] {
    return a.flatMap(f)
}

/**
 compose two functions that produce arrays of values, from left to right
 
 produces a function that applies that flatMaps the second function over each element in the result of the first function
 
 - parameter f: A transformation function from type `A` to type `[B]`
 - parameter g: A transformation function from type `B` to type `[C]`
 
 - returns: A value of type `[C]`
 */
public func >-> <A, B, C>(f: @escaping (A) -> [B], g: @escaping (B) -> [C]) -> (A) -> [C] {
    return { x in f(x) >>- g }
}

/**
 compose two functions that produce arrays of values, from right to left
 
 produces a function that applies that flatMaps the first function over each element in the result of the second function
 
 - parameter f: A transformation function from type `B` to type `[C]`
 - parameter g: A transformation function from type `A` to type `[B]`
 
 - returns: A value of type `[C]`
 */
public func <-< <A, B, C>(f: @escaping (B) -> [C], g: @escaping (A) -> [B]) -> (A) -> [C] {
    return { x in g(x) >>- f }
}

/**
 Wrap a value in a minimal context of `[]`
 
 - parameter a: A value of type `T`
 
 - returns: The provided value wrapped in an array
 */
public func pure<T>(_ a: T) -> [T] {
    return [a]
}

public extension Array {
    /**
     apply an array of functions to `self`
     
     This will return a new array resulting from the matrix of each function being applied to each value inside `self`
     
     - parameter fs: An array of transformation functions from type `Element` to type `U`
     
     - returns: A value of type `[U]`
     */
    func apply<U>(_ fs: [(Element) -> U]) -> [U] {
        return fs.flatMap { self.map($0) }
    }
}
