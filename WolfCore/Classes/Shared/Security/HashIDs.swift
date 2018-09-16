//
//  HashIDs.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/26/15.
//  Copyright © 2015 WolfMcNally.com.
//

//
//  HashIds.swift
//  http://hashids.org
//
//  Author https://github.com/malczak
//  Licensed under the MIT license.
//

//import Foundation

// MARK: Hashids options

#if canImport(Glibc)
    import Glibc
#elseif canImport(Darwin)
    import Darwin
#endif

public struct HashidsOptions
{
    static let version = "1.1.0"
    static var minAlphabetLength: Int = 16
    static var sepDiv = 3.5
    static var guardDiv = 12.0
    static var alphabet: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    static var separators: String = "cfhistuCFHISTU"
}


// MARK: Hashids protocol

public protocol HashidsGenerator {
    associatedtype Char

    func encode(_ value: Int...) -> String?
    func encode(_ values: [Int]) -> String?
    func decode(_ value: String!) -> [Int]
    func decode(_ value: [Char]) -> [Int]
}


// MARK: Hashids class

public typealias Hashids = Hashids_<UInt32>


// MARK: Hashids generic class

public class Hashids_<T> : HashidsGenerator where T: UnsignedInteger {
    public typealias Char = T

    private var minHashLength: UInt

    private var alphabet: [Char]

    private var seps: [Char]

    private var salt: [Char]

    private var guards: [Char]

    public init(salt: String!, minHashLength: UInt = 0, alphabet: String? = nil) {
        var _alphabet = (alphabet != nil) ? alphabet! : HashidsOptions.alphabet
        var _seps = HashidsOptions.separators

        self.minHashLength = minHashLength
        self.guards = [Char]()
        self.salt = salt.unicodeScalars.map { numericCast($0.value) }
        self.seps = _seps.unicodeScalars.map { numericCast($0.value) }
        self.alphabet = unique( _alphabet.unicodeScalars.map { numericCast($0.value) })

        self.seps = intersection(self.alphabet, self.seps)
        self.alphabet = difference(self.alphabet, self.seps)
        shuffle(&self.seps, self.salt)


        let sepsLength = self.seps.count
        let alphabetLength = self.alphabet.count

        if (0 == sepsLength) || (Double(alphabetLength) / Double(sepsLength) > HashidsOptions.sepDiv) {

            var newSepsLength = Int(ceil(Double(alphabetLength) / HashidsOptions.sepDiv))

            if 1 == newSepsLength {
                newSepsLength += 1
            }

            if newSepsLength > sepsLength {
                let diff = self.alphabet.index(self.alphabet.startIndex, offsetBy: newSepsLength - sepsLength)
                let range = 0..<diff
                self.seps += self.alphabet[range]
                self.alphabet.removeSubrange(range)
            } else {
                let pos = self.seps.index(self.seps.startIndex, offsetBy: newSepsLength)
                self.seps.removeSubrange(pos+1..<self.seps.count)
            }
        }

        shuffle(&self.alphabet, self.salt)

        let guard_i = Int(ceil(Double(alphabetLength)/HashidsOptions.guardDiv))
        if alphabetLength < 3 {
            let seps_guard = self.seps.index(self.seps.startIndex, offsetBy: guard_i)
            let range = 0..<seps_guard
            self.guards += self.seps[range]
            self.seps.removeSubrange(range)
        } else {
            let alphabet_guard = self.alphabet.index(self.alphabet.startIndex, offsetBy: guard_i)
            let range = 0..<alphabet_guard
            self.guards += self.alphabet[range]
            self.alphabet.removeSubrange(range)
        }
    }

    // MARK: public api

    public func encode(_ value: Int...) -> String? {
        return encode(value)
    }

    public func encode(_ values: [Int]) -> String? {
        let ret = _encode(values)
        return ret.reduce(String()) { (so, i) in
            let ui: UInt32 = numericCast(i)
            let scalar = UnicodeScalar(ui)!
            let char = Character(scalar)
            let s = String(char)
            return so + s
        }
    }

    public func decode(_ value: String!) -> [Int] {
        let hash: [Char] = value.unicodeScalars.map { numericCast($0.value) }
        return self.decode(hash)
    }

    public func decode(_ value: [Char]) -> [Int] {
        return self._decode(value)
    }

    // MARK: private functions

    private func _encode(_ numbers: [Int]) -> [Char] {
        var alphabet = self.alphabet
        var numbers_hash_int = 0

        for (index, value) in numbers.enumerated() {
            numbers_hash_int += ( value  % ( index + 100 ) )
        }

        let lottery = alphabet[numbers_hash_int % alphabet.count]
        var hash = [lottery]

        var lsalt = [Char]()
        let (lsaltARange, lsaltRange) = _saltify(&lsalt, lottery, alphabet)

        for (index, value) in numbers.enumerated() {
            shuffle(&alphabet, lsalt, lsaltRange)
            let lastIndex = hash.endIndex
            _hash(&hash, value, alphabet)

            if index + 1 < numbers.count {
                let number = value % (numericCast(hash[lastIndex]) + index)
                let seps_index = number % self.seps.count
                hash.append(self.seps[seps_index])
            }

            lsalt.replaceSubrange(lsaltARange, with: alphabet)
        }

        let minLength: Int = numericCast(self.minHashLength)

        if hash.count < minLength {
            let guard_index = (numbers_hash_int + numericCast(hash[0])) % self.guards.count
            let guard_t = self.guards[guard_index]
            hash.insert(guard_t, at: 0)

            if hash.count < minLength {
                let guard_index = (numbers_hash_int + numericCast(hash[2])) % self.guards.count
                let guard_t = self.guards[guard_index]
                hash.append(guard_t)
            }
        }

        let half_length: Int = alphabet.count >> 1
        while hash.count < minLength {
            shuffle(&alphabet, alphabet)
            let lrange = alphabet.startIndex..<alphabet.index(alphabet.startIndex, offsetBy: half_length)
            let rrange = alphabet.index(alphabet.startIndex, offsetBy: half_length)..<alphabet.endIndex
            let a = alphabet[rrange]
            let b = alphabet[lrange]
            hash = a + hash + b

            let excess = hash.count - minLength
            if excess > 0 {
                let start = excess >> 1
                hash = [Char](hash[start..<(start+minLength)])
            }
        }

        return hash
    }

    private func _decode(_ hash: [Char]) -> [Int] {
        var ret = [Int]()

        var alphabet = self.alphabet

        var hashes = hash.split(omittingEmptySubsequences: false) { contains(self.guards, $0) }
        //        var hashes = hash.split( hash.count, allowEmptySlices: true) { contains(self.guards, $0) }
        let hashesCount = hashes.count, i = ((hashesCount == 2) || (hashesCount == 3)) ? 1 : 0
        let hash = hashes[i]

        if hash.count > 0 {
            let lottery = hash[0]
            let valuesHashes = hash[1..<hash.count]

            let valueHashes = valuesHashes.split(omittingEmptySubsequences: false) { contains(self.seps, $0) }
            //            let valueHashes = valuesHashes.split(valuesHashes.count, allowEmptySlices: true) { contains(self.seps, $0) }
            var lsalt = [Char]()
            let (lsaltARange, lsaltRange) = _saltify(&lsalt, lottery, alphabet)

            for subHash in valueHashes {
                shuffle(&alphabet, lsalt, lsaltRange)
                ret.append(self._unhash(subHash, alphabet))
                lsalt.replaceSubrange(lsaltARange, with: alphabet)
            }
        }

        return ret
    }

    private func _hash(_ hash: inout [Char], _ number: Int, _ alphabet: [Char]) {
        let length = alphabet.count, index = hash.count
        var number = number
        repeat {
            hash.insert(alphabet[number % length], at: index)
            number /= length
        } while number != 0
    }

    private func _unhash<U: Collection>(_ hash: U, _ alphabet: [Char]) -> Int where U.Index == Int, U.Iterator.Element == Char {
        var value = 0.0

        var hashLength = hash.count
        if hashLength > 0 {
            let alphabetLength = alphabet.count
            value = hash.reduce(0) { value, token in
                var tokenValue = 0.0
                if let token_index = alphabet.index(of: token as Char) {
                    hashLength -= 1
                    let mul = pow(Double(alphabetLength), Double(hashLength))
                    tokenValue = Double(token_index) * mul
                }
                return value + tokenValue
            }
        }

        return Int(trunc(value))
    }

    private func _saltify(_ salt: inout [Char], _ lottery: Char, _ alphabet: [Char]) -> (CountableRange<Int>, CountableRange<Int>) {
        salt.append(lottery)
        salt += self.salt
        salt += alphabet
        let lsaltARange = (self.salt.count + 1)..<salt.count
        let lsaltRange = 0..<alphabet.count
        return (lsaltARange, lsaltRange)
    }
}

// MARK: Internal functions

internal func contains<T: Collection>(_ a: T, _ e: T.Iterator.Element) -> Bool where T.Iterator.Element: Equatable {
    return (a.index(of: e) != nil)
}

internal func transform<T: Collection>(_ a: T, _ b: T, _ cmpr: (inout [T.Iterator.Element], T, T, T.Iterator.Element ) -> Void ) -> [T.Iterator.Element] where T.Iterator.Element: Equatable {
    typealias U = T.Iterator.Element
    var c = [U]()
    for i in a {
        cmpr(&c, a, b, i)
    }
    return c
}

internal func unique<T: Collection>(_ a: T) -> [T.Iterator.Element] where T.Iterator.Element: Equatable {
    return transform(a, a) { (c, _, _, e) in
        var c = c
        if !contains(c, e) {
            c.append(e)
        }
    }
}

internal func intersection<T: Collection>(_ a: T, _ b: T) -> [T.Iterator.Element] where T.Iterator.Element: Equatable {
    return transform(a, b) { (c, _, b, e) in
        var c = c
        if contains(b, e) {
            c.append(e)
        }
    }
}

internal func difference<T: Collection>(_ a: T, _ b: T) -> [T.Iterator.Element] where T.Iterator.Element: Equatable {
    return transform(a, b) { (c, _, b, e) in
        var c = c
        if !contains(b, e) {
            c.append(e)
        }
    }
}

internal func shuffle<T: MutableCollection, U: Collection>(_ source: inout T, _ salt: U) where T.Index == Int, T.Iterator.Element: UnsignedInteger, T.Iterator.Element == U.Iterator.Element, T.Index == U.Index {
    return shuffle(&source, salt, 0..<salt.count)
}

internal func shuffle<T: MutableCollection, U: Collection>(_ source: inout T, _ salt: U, _ saltRange: CountableRange<Int>) where T.Index == Int, T.Iterator.Element: UnsignedInteger, T.Iterator.Element == U.Iterator.Element, T.Index == U.Index {
    let sidx0 = saltRange.lowerBound, scnt = (saltRange.upperBound - saltRange.lowerBound)
    var sidx: Int = source.count - 1
    var v = 0
    var _p = 0
    while sidx > 0 {
        v = v % scnt
        let _i: Int = numericCast(salt[sidx0 + v])
        _p += _i
        let _j: Int = (_i + v + _p) % sidx
        let tmp = source[sidx]
        source[sidx] = source[_j]
        source[_j] = tmp
        v += 1
        sidx -= 1
    }
}
