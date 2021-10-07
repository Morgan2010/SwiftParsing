//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation


/// A data structure for easily indexing strings.
struct IndexableSubString: Collection, IteratorProtocol {
    
    typealias Element = Character
    
    typealias Index = String.Index
    
    /// The total number of utf16 elements in the substring.
    var count: Int {
        indexes.upperBound.utf16Offset(in: parent) - indexes.lowerBound.utf16Offset(in: parent)
    }
    
    private var currentIndex: String.Index
    
    /// The last index in the substring. Indexes are represented with respect to the parent string.
    var endIndex: String.Index {
        indexes.upperBound
    }
    
    /// The range of indexes this substring represents in the parent string.
    let indexes: Range<String.Index>
    
    /// The parent string this substring was created from.
    let parent: String
    
    /// The first index in this substring. Indexes are represented with respect to the parent string.
    var startIndex: String.Index {
        indexes.lowerBound
    }
    
    /// The `Substring` representation of this object.
    var value: Substring {
        parent[indexes]
    }
    
    /// Creates a substring from a parent string.
    /// - Parameters:
    ///   - parent: The parent string this substring was created from.
    ///   - indexes: The indexes in the parent string that this substring was drawn from.
    init(parent: String, indexes: Range<String.Index>) {
        self.parent = parent
        self.indexes = indexes
        self.currentIndex = indexes.lowerBound
    }
    
    /// Retries the next index in the sequence.
    /// - Parameter i: The index immediately before the new index.
    /// - Returns: The index immediately after i. This index is bounded to the size of the substring.
    func index(after i: String.Index) -> String.Index {
        guard let newIndex = i.increment(in: parent) else {
            return i
        }
        return newIndex
    }
    
    /// Finds the first index that satisfies a condition.
    /// - Parameter filter: The condition to be satisfied.
    /// - Returns: An optional `String.Index` representing the first index to satisfy the condition.
    func firstIndex(where filter: (Character) -> Bool) -> String.Index? {
        guard let rawIndex = parent[indexes].firstIndex(where: filter) else {
            return nil
        }
        return rawIndex
    }
    
    /// Retrieves the next valid character in the substring. Used for looping purposes.
    /// - Returns: The next character.
    mutating func next() -> Character? {
        let result = parent[currentIndex]
        guard let newIndex = currentIndex.increment(in: parent) else {
            return result
        }
        currentIndex = newIndex
        return result
        
    }
    
    /// Allows this object to be subscipted by `String.Index` instances.
    subscript(position: String.Index) -> Character {
        parent[position]
    }
    
}
