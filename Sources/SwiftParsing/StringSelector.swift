//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation

struct StringSelector {
    
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
    
    func findSubString(after index: String.Index, with balancedLower: Character, and balancedUpper: Character, in parent: String) -> IndexableSubString? {
        self.findSubString(after: index, between: Set(arrayLiteral: balancedLower), and: Set(arrayLiteral: balancedUpper), in: parent)
    }
    
    func findSubString(after index: String.Index, between balancedLower: Set<Character>, and balancedUpper: Set<Character>, in parent: String) -> IndexableSubString? {
        guard let startIndex = index.increment(in: parent) else {
            return nil
        }
        let viableChoices = IndexableSubString(parent: parent, indexes: startIndex..<parent.lastIndex)
        guard
            let firstCandidate = viableChoices.firstIndex(where: { balancedLower.contains($0) }),
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
