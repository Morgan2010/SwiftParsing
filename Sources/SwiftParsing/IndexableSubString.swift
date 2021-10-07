//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation

struct IndexableSubString: Collection, IteratorProtocol {
    
    typealias Element = Character
    
    typealias Index = String.Index
    
    var count: Int {
        indexes.upperBound.utf16Offset(in: parent) - indexes.lowerBound.utf16Offset(in: parent)
    }
    
    private var currentIndex: String.Index
    
    var endIndex: String.Index {
        indexes.upperBound
    }
    
    let indexes: Range<String.Index>
    
    let parent: String
    
    var startIndex: String.Index {
        indexes.lowerBound
    }
    
    var value: Substring {
        parent[indexes]
    }
    
    init(parent: String, indexes: Range<String.Index>) {
        self.parent = parent
        self.indexes = indexes
        self.currentIndex = indexes.lowerBound
    }
    
    func index(after i: String.Index) -> String.Index {
        guard let newIndex = i.increment(in: parent) else {
            return i
        }
        return newIndex
    }
    
    func firstIndex(where filter: (Character) -> Bool) -> String.Index? {
        guard let rawIndex = parent[indexes].firstIndex(where: filter) else {
            return nil
        }
        return rawIndex.addToIndex(amount: startIndex.utf16Offset(in: parent), in: parent)
    }
    
    mutating func next() -> Character? {
        let result = parent[currentIndex]
        guard let newIndex = currentIndex.increment(in: parent) else {
            return result
        }
        currentIndex = newIndex
        return result
        
    }
    
    subscript(position: String.Index) -> Character {
        parent[position]
    }
    
}
