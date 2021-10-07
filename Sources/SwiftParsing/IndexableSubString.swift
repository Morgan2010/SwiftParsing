//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation

@available(macOSApplicationExtension 10.15.0, *)
struct IndexableSubString: Collection, IteratorProtocol {
    
    typealias Element = Character
    
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
    
    func index(after i: String.Index) -> String.Index {
        guard let newIndex = incrementIndex(index: i) else {
            return i
        }
        return newIndex
    }
    
    mutating func next() -> Character? {
        let result = parent[currentIndex]
        guard let newIndex = incrementIndex(index: currentIndex) else {
            return result
        }
        currentIndex = newIndex
        return result
        
    }
    
    subscript(position: String.Index) -> Character {
        parent[position]
    }
    
    private func incrementIndex(index: String.Index) -> String.Index? {
        let utfIndex = currentIndex.utf16Offset(in: parent)
        guard utfIndex < (parent.count - 1) else {
            return nil
        }
        return String.Index(utf16Offset: utfIndex + 1, in: parent)
    }
    
}
