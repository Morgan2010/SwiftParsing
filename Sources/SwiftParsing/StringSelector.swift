//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation


/// A struct to help find sub strings within a parent string.
public struct StringSelector {
    
    public init() {}
    
    public func findIndexes(for word: String, in parent: String) -> IndexableSubString? {
        guard let firstIndex = parent.firstIndex else {
            return nil
        }
        return findIndexes(for: word, in: IndexableSubString(parent: parent, indexes: firstIndex..<parent.countIndex))
    }
    
    public func findIndexes(for word: String, after index: String.Index, in parent: String) -> IndexableSubString? {
        guard
            index < parent.countIndex,
            let firstIndex = index.increment(in: parent)
        else {
            return nil
        }
        let range = firstIndex..<parent.countIndex
        return findIndexes(for: word, in: IndexableSubString(parent: parent, indexes: range))
    }
    
    public func findSubString(between balancedFirst: Character, and balancedLast: Character, in parent: String) -> IndexableSubString? {
        findSubString(between: [balancedFirst], and: [balancedLast], in: parent)
    }
    
    public func findSubString(between balancedLower: Set<Character>, and balancedUpper: Set<Character>, in parent: String) -> IndexableSubString? {
        guard let range = findRangeForStartingCharacters(in: parent, for: balancedLower) else {
            return nil
        }
        let candidates = IndexableSubString(parent: parent, indexes: range)
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
                return IndexableSubString(parent: parent, indexes: range.lowerBound..<i)
            }
        }
        return nil
    }
    
    /// Finds a substring between 2 characters and after an index in a parent string.
    /// - Parameters:
    ///   - index: The index just before the first index which is checked in the parent string.
    ///   - first: The delimiting character which signifies the start of the target string.
    ///   - last: The delimiting character which signifies the end of the target string.
    ///   - parent: The string to search.
    /// - Returns: An optional `IndexableSubString` which represents the found string.
    public func findSubString(after index: String.Index, between first: Character, and last: Character, in parent: String) -> IndexableSubString? {
        guard
            let range = findRangeForStartingCharacter(in: parent, for: first, after: index),
            let upperBound = IndexableSubString(parent: parent, indexes: range).firstIndex(where: { $0 == last }),
            upperBound > range.lowerBound
        else {
            return nil
        }
        return IndexableSubString(parent: parent, indexes: range.lowerBound..<upperBound)
    }
    
    
    /// Finds a sub string which exists between 2 delimiting characters and after an index in a parent string. This function
    /// ensures that the starting character will be matched precisely with an ending character.
    /// - Parameters:
    ///   - index: The index immediately before the first candidate to search.
    ///   - balancedLower: The character immediately before the start of the sequence.
    ///   - balancedUpper: The character immediately after the end of the sequence.
    ///   - parent: The string to search.
    /// - Returns: An optional `IndexableSubString` representing the string that was found.
    public func findSubString(after index: String.Index, with balancedLower: Character, and balancedUpper: Character, in parent: String) -> IndexableSubString? {
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
    public func findSubString(after index: String.Index, between balancedLower: Set<Character>, and balancedUpper: Set<Character>, in parent: String) -> IndexableSubString? {
        guard let range = findRangeForStartingCharacters(in: parent, for: balancedLower, after: index) else {
            return nil
        }
        let candidates = IndexableSubString(parent: parent, indexes: range)
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
                return IndexableSubString(parent: parent, indexes: range.lowerBound..<i)
            }
        }
        return nil
    }
    
    private func findIndexes(for word: String, in parent: IndexableSubString) -> IndexableSubString? {
        let candidates = parent
        let wordCount = word.count
        for i in candidates.indices {
            guard
                let lastWordIndex = i.addToIndex(amount: wordCount, in: parent.parent),
                lastWordIndex <= parent.endIndex
            else {
                return nil
            }
            let candidateRange = i..<lastWordIndex
            if parent.parent[candidateRange] == word {
                return IndexableSubString(parent: parent.parent, indexes: candidateRange)
            }
        }
        return nil
    }
    
    private func findRangeForStartingCharacter(in parent: String, for char: Character, after index: String.Index) -> Range<String.Index>? {
        findRangeForStartingCharacters(in: parent, for: Set(arrayLiteral: char), after: index)
    }
    
    private func findRangeForStartingCharacters(in parent: String, for chars: Set<Character>) -> Range<String.Index>? {
        guard
            let firstCandidate = parent.firstIndex(where: { chars.contains($0) }),
            firstCandidate != parent.lastIndex,
            let firstIndex = firstCandidate.increment(in: parent)
        else {
            return nil
        }
        return firstIndex..<parent.countIndex
    }
    
    private func findRangeForStartingCharacters(in parent: String, for chars: Set<Character>, after index: String.Index) -> Range<String.Index>? {
        guard let startIndex = index.increment(in: parent) else {
            return nil
        }
        let viableChoices = IndexableSubString(parent: parent, indexes: startIndex..<parent.countIndex)
        guard
            let firstCandidate = viableChoices.firstIndex(where: { chars.contains($0) }),
            firstCandidate != parent.lastIndex,
            let firstIndex = firstCandidate.increment(in: parent)
        else {
            return nil
        }
        return firstIndex..<parent.countIndex
    }
    
}
