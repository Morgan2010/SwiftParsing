//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation


/// A struct to help find sub strings within a parent string.
public extension String {
    
    func findIndexes(for word: String) -> IndexableSubString? {
        guard let firstIndex = self.firstIndex else {
            return nil
        }
        return findIndexes(for: word, in: IndexableSubString(parent: self, indexes: firstIndex..<self.countIndex))
    }
    
    func findIndexes(for word: String, after index: String.Index) -> IndexableSubString? {
        guard
            index < self.countIndex,
            let firstIndex = index.increment(in: self)
        else {
            return nil
        }
        let range = firstIndex..<self.countIndex
        return findIndexes(for: word, in: IndexableSubString(parent: self, indexes: range))
    }
    
    func findSubString(with first: Character, and last: Character) -> IndexableSubString? {
        guard
            let range = self.findRangeForStartingCharacters(for: [first]),
            let lastIndex = IndexableSubString(parent: self, indexes: range).firstIndex(where: { $0 == last })
        else {
            return nil
        }
        return IndexableSubString(parent: self, indexes: range.lowerBound..<lastIndex)
    }
    
    func findSubString(between balancedFirst: Character, and balancedLast: Character) -> IndexableSubString? {
        self.findSubString(between: [balancedFirst], and: [balancedLast])
    }
    
    func findSubString(between balancedLower: Set<Character>, and balancedUpper: Set<Character>) -> IndexableSubString? {
        guard let range = self.findRangeForStartingCharacters(for: balancedLower) else {
            return nil
        }
        let candidates = IndexableSubString(parent: self, indexes: range)
        var count = 1
        for i in candidates.indices {
            let c = self[i]
            if balancedLower.contains(c) {
                count = count + 1
                continue
            }
            if balancedUpper.contains(c) {
                count = count - 1
            }
            if count == 0 {
                return IndexableSubString(parent: self, indexes: range.lowerBound..<i)
            }
        }
        return nil
    }
    
    /// Finds a substring between 2 characters and after an index in a parent string.
    /// - Parameters:
    ///   - index: The index just before the first index which is checked in the parent string.
    ///   - first: The delimiting character which signifies the start of the target string.
    ///   - last: The delimiting character which signifies the end of the target string.
    /// - Returns: An optional `IndexableSubString` which represents the found string.
    func findSubString(after index: String.Index, between first: Character, and last: Character) -> IndexableSubString? {
        guard
            let range = self.findRangeForStartingCharacter(for: first, after: index),
            let upperBound = IndexableSubString(parent: self, indexes: range).firstIndex(where: { $0 == last }),
            upperBound > range.lowerBound
        else {
            return nil
        }
        return IndexableSubString(parent: self, indexes: range.lowerBound..<upperBound)
    }
    
    
    /// Finds a sub string which exists between 2 delimiting characters and after an index in a parent string. This function
    /// ensures that the starting character will be matched precisely with an ending character.
    /// - Parameters:
    ///   - index: The index immediately before the first candidate to search.
    ///   - balancedLower: The character immediately before the start of the sequence.
    ///   - balancedUpper: The character immediately after the end of the sequence.
    /// - Returns: An optional `IndexableSubString` representing the string that was found.
    func findSubString(after index: String.Index, with balancedLower: Character, and balancedUpper: Character) -> IndexableSubString? {
        self.findSubString(after: index, between: Set(arrayLiteral: balancedLower), and: Set(arrayLiteral: balancedUpper))
    }
    
    
    /// Finds a sub string which exists between multiple possible start & end characters, and after an index in a parent string.
    /// This function ensures that starting characters are balanced with ending characters, i.e. the amount of starting characters
    /// must equal the amount of ending characters for a match.
    /// - Parameters:
    ///   - index: The index immediately before the first candidate character.
    ///   - balancedLower: The set of characters that starts the target string.
    ///   - balancedUpper: The set of possible characters immediately after the target string.
    /// - Returns: An optional `IndexableSubString` which represents the found sub string.
    func findSubString(after index: String.Index, between balancedLower: Set<Character>, and balancedUpper: Set<Character>) -> IndexableSubString? {
        guard let range = self.findRangeForStartingCharacters(for: balancedLower, after: index) else {
            return nil
        }
        let candidates = IndexableSubString(parent: self, indexes: range)
        var count = 1
        for i in candidates.indices {
            let c = self[i]
            if balancedLower.contains(c) {
                count = count + 1
                continue
            }
            if balancedUpper.contains(c) {
                count = count - 1
            }
            if count == 0 {
                return IndexableSubString(parent: self, indexes: range.lowerBound..<i)
            }
        }
        return nil
    }
    
    func findSubString(after index: String.Index, with starting: Set<Character>, and ending: Set<Character>) -> IndexableSubString? {
        guard
            let range = self.findRangeForStartingCharacters(for: starting, after: index),
            let lastIndex = IndexableSubString(parent: self, indexes: range).firstIndex(where: { ending.contains($0) })
        else {
            return nil
        }
        return IndexableSubString(parent: self, indexes: range.lowerBound..<lastIndex)
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
    
    private func findRangeForStartingCharacter(for char: Character, after index: String.Index) -> Range<String.Index>? {
        self.findRangeForStartingCharacters(for: Set(arrayLiteral: char), after: index)
    }
    
    private func findRangeForStartingCharacters(for chars: Set<Character>) -> Range<String.Index>? {
        guard
            let firstCandidate = self.firstIndex(where: { chars.contains($0) }),
            firstCandidate != self.lastIndex,
            let firstIndex = firstCandidate.increment(in: self)
        else {
            return nil
        }
        return firstIndex..<self.countIndex
    }
    
    private func findRangeForStartingCharacters(for chars: Set<Character>, after index: String.Index) -> Range<String.Index>? {
        guard let startIndex = index.increment(in: self) else {
            return nil
        }
        let viableChoices = IndexableSubString(parent: self, indexes: startIndex..<self.countIndex)
        guard
            let firstCandidate = viableChoices.firstIndex(where: { chars.contains($0) }),
            firstCandidate != self.lastIndex,
            let firstIndex = firstCandidate.increment(in: self)
        else {
            return nil
        }
        return firstIndex..<self.countIndex
    }
    
}
