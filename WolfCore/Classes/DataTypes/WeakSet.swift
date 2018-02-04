//
//  WeakSet.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/28/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

//
//  Based on WeakSet by Adam Preble.
//

//import Foundation

/// Weak, unordered collection of objects.
public struct WeakSet<T> where T: AnyObject, T: Hashable {
    public typealias Element = T
    public typealias Entry = Weak<Element>
    
    /// Maps Element hashValues to arrays of Entry objects.
    /// Invalid Entry instances are culled as a side effect of add() and remove()
    /// when they touch an object with the same hashValue.
    public typealias Contents = [Int: [Entry]]
    
    fileprivate var contents = Contents()
    
    public init(_ objects: T...) {
        self.init(objects)
    }
    
    public init(_ objects: [T]) {
        for object in objects {
            insert(object)
        }
    }
    
    /// Inserts the given element in the set if it is not already present.
    @discardableResult public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let hash = newMember.hashValue
        var entriesAtHash = validEntriesAtHash(hash)
        for entry in entriesAtHash {
            if let oldMember = entry.element {
                if oldMember == newMember {
                    return (false, oldMember)
                }
            }
        }
        let entry = Entry(element: newMember)
        entriesAtHash.append(entry)
        contents[hash] = entriesAtHash
        return (true, newMember)
    }
    
    /// Removes the specified element from the set.
    @discardableResult public mutating func remove(_ member: Element) -> Element? {
        let hash = member.hashValue
        var entriesAtHash = validEntriesAtHash(hash)
        if let index = entriesAtHash.index(where: { $0.element == member }) {
            let entryAtIndex = entriesAtHash[index]
            entriesAtHash.remove(at: index)
            if entriesAtHash.isEmpty {
                contents[hash] = nil
            } else {
                contents[hash] = entriesAtHash
            }
            return entryAtIndex.element
        } else {
            return nil
        }
    }
    
    /// Returns a Boolean value that indicates whether the given element exists
    /// in the set.
    public func contains(_ member: Element) -> Bool {
        let entriesAtHash = validEntriesAtHash(member.hashValue)
        for entry in entriesAtHash {
            if entry.element == member {
                return true
            }
        }
        return false
    }
    
    private func validEntriesAtHash(_ hashValue: Int) -> [Entry] {
        if let entries = contents[hashValue] {
            return entries.filter {
                $0.element != nil
            }
        }
        else {
            return []
        }
    }
    
    public struct Iterator: IteratorProtocol {
        var n: () -> T?
        
        public init(_ s: WeakSet<Element>) {
            var contentsIterator = s.contents.values.makeIterator()         // generates arrays of entities
            var entryIterator = contentsIterator.next()?.makeIterator()  // generates entries
            n = {
                // Note: If entryIterator is nil, the party is over. No more.
                if let element = entryIterator?.next()?.element {
                    return element
                }
                else { // Ran out of entities in this array. Get the next one, if there is one.
                    entryIterator = contentsIterator.next()?.makeIterator()
                    return entryIterator?.next()?.element
                }
            }
        }
        
        public mutating func next() -> T? {
            return n()
        }
    }
}


// MARK: SequenceType

extension WeakSet: Sequence {
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}

/**
 
 // Example of using WeakSet:
 
 class Animal: Hashable, CustomStringConvertible {
 let name: String
 
 init(name: String) {
 self.name = name
 }
 
 var hashValue: Int {
 return name.hashValue
 }
 
 static func == (lhs: Animal, rhs: Animal) -> Bool {
 return lhs.name == rhs.name
 }
 
 var description: String {
 return name
 }
 }
 
 // These are the only strong references to these objects.
 var dog: Animal! = Animal(name: "dog")
 var cat: Animal! = Animal(name: "cat")
 var giraffe: Animal! = Animal(name: "giraffe")
 
 var animals = WeakSet<Animal>()
 
 animals.insert(dog)
 animals.insert(cat)
 animals.insert(giraffe)
 print ("After initial inserts:")
 for animal in animals { print(animal) }
 
 // Prints:
 //    After initial inserts:
 //    giraffe
 //    cat
 //    dog
 
 giraffe = nil
 print ("After giraffe becomes nil:")
 for animal in animals { print(animal) }
 
 // Prints:
 //    After giraffe becomes nil:
 //    cat
 //    dog
 
 animals.remove(dog)
 print ("After removing dog:")
 for animal in animals { print(animal) }
 
 // Prints:
 //    After removing dog:
 //    cat
 
 cat = nil
 print ("After cat becomes nil:")
 for animal in animals { print(animal) }
 
 // Prints:
 //    After cat becomes nil:
 
 **/
