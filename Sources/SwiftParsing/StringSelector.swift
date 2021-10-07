//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation


/// A struct to help find sub strings within a parent string.
struct StringSelector {
    
    
    /// Finds a substring between 2 characters and after an index in a parent string.
    /// - Parameters:
    ///   - index: The index just before the first index which is checked in the parent string.
    ///   - first: The delimiting character which signifies the start of the target string.
    ///   - last: The delimiting character which signifies the end of the target string.
    ///   - parent: The string to search.
    /// - Returns: An optional `IndexableSubString` which represents the found string.
    func findSubString(after index: String.Index, between first: Character, and last: Character, in parent: String) -> IndexableSubString? {
        guard let startIndex = index.increment(in: parent) else {
            return nil
        }
        let candidates = IndexableSubString(parent: parent, indexes: startIndex..<parent.lastIndex)
        guard
            let lowerBound = candidates.firstIndex(where: { $0 == first })?.increment(in: parent),
            let upperBound = candidates[lowerBound..<parent.lastIndex].firstIndex(where: { $0 == last }),
            upperBound > lowerBound
        else {
            return nil
        }
        return IndexableSubString(parent: parent, indexes: lowerBound..<upperBound)
    }
    
    
    /// Finds a sub string which exists between 2 delimiting characters and after an index in a parent string. This function
    /// ensures that the starting character will be matched precisely with an ending character.
    /// - Parameters:
    ///   - index: The index immediately before the first candidate to search.
    ///   - balancedLower: The character immediately before the start of the sequence.
    ///   - balancedUpper: The character immediately after the end of the sequence.
    ///   - parent: The string to search.
    /// - Returns: An optional `IndexableSubString` representing the string that was found.
    func findSubString(after index: String.Index, with balancedLower: Character, and balancedUpper: Character, in parent: String) -> IndexableSubString? {
        self.findSubString(after: index, between: Set(arrayLiteral: balancedLower), and: Set(arrayLiteral: balancedUpper), in: parent)
    }
    
    
    /// Finds a sub string which exists between multiple possible start & end characters, and after an index in a parent string.
    /// This function ensures that starting characters are balanced with ending characters, i.e. the amount of starting characters
    /// must equal the amount of ending characters for a match.
    /// - Parameters:
    ///   - index: The index immediately before the first candidate character.
    ///   - balancedLower: The set of characters that starts the target string.
    ///   - balancedUpper: The set of possible characters immediately after the target string.
    ///   - parent: The string to search.
    /// - Returns: An optional `IndexableSubString` which represents the found sub string.
    func findSubString(after index: String.Index, between balancedLower: Set<Character>, and balancedUpper: Set<Character>, in parent: String) -> IndexableSubString? {
        guard let startIndex = index.increment(in: parent) else {
            return nil
        }
        let viableChoices = IndexableSubString(parent: parent, indexes: startIndex..<parent.lastIndex)
        guard
            let firstCandidate = viableChoices.firstIndex(where: { balancedLower.contains($0) }),
            firstCandidate != parent.lastIndex,
            let firstIndex = firstCandidate.increment(in: parent)
        else {
            return nil
        }
        let candidates = IndexableSubString(parent: parent, indexes: firstIndex..<parent.lastIndex)
        var count = 1
        for i in candidates.indices {
            let c = parent[i]
            if balancedLower.contains(c) {
                count = count + 1
                continue
            }
            if balancedUpper.contains(c) {
                count = count - 1
            }
            if count == 0 {
                return IndexableSubString(parent: parent, indexes: firstIndex..<i)
            }
        }
        return nil
    }
    
}
