//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation

/// Adds some helper functions for changing the value of an index with respect to a string.
public extension String.Index {
    
    /// Add a utf16 offset to an index.
    /// - Parameters:
    ///   - amount: The amount to increment.
    ///   - parent: The reference string that this index is used in.
    /// - Returns: A new index. The index is bounded to the size of the parent string.
    func addToIndex(amount: Int, in parent: String) -> String.Index? {
        let newIndex = self.utf16Offset(in: parent) + amount
        guard newIndex < parent.count else {
            return nil
        }
        return String.Index(utf16Offset: newIndex, in: parent)
    }
    
    /// Increments the index by 1 utf16 offset.
    /// - Parameter parent: The parent this index is used in.
    /// - Returns: The new index. The index is bounded to the size of the parent string.
    func increment(in parent: String) -> String.Index? {
        let newIndex = self.utf16Offset(in: parent) + 1
        guard newIndex < parent.count else {
            return nil
        }
        return String.Index(utf16Offset: newIndex, in: parent)
    }
    
    /// Decrements the inex by 1 utf16 offset
    /// - Parameter parent: The parent this index is used in.
    /// - Returns: The new index. The index is bounded to the size of the parent string.
    func decrement(in parent: String) -> String.Index? {
        let newIndex = self.utf16Offset(in: parent) - 1
        guard newIndex > 0 else {
            return nil
        }
        return String.Index(utf16Offset: newIndex, in: parent)
    }
    
}

public extension StringProtocol {
    
    /// Helper property for retrieving the first index in a string.
    var firstIndex: String.Index? {
        guard self.count > 0 else {
            return nil
        }
        return String.Index(utf16Offset: 0, in: self)
    }
    
    /// Helper property for retrieving the last index in a string.
    var lastIndex: String.Index? {
        guard self.count > 0 else {
            return nil
        }
        return String.Index(utf16Offset: self.count - 1, in: self)
    }
    
    /// The index immediately after the end of the string. Indexing the string with this index will return an out-of-bounds error.
    var countIndex: String.Index {
        String.Index(utf16Offset: self.count, in: self)
    }
    
}
