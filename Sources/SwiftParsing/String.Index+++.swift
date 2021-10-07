//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation

extension String.Index {
    
    func addToIndex(amount: Int, in parent: String) -> String.Index? {
        let newIndex = self.utf16Offset(in: parent) + amount
        guard newIndex < parent.count else {
            return nil
        }
        return String.Index(utf16Offset: newIndex, in: parent)
    }
    
    func increment(in parent: String) -> String.Index? {
        let newIndex = self.utf16Offset(in: parent) + 1
        guard newIndex < parent.count else {
            return nil
        }
        return String.Index(utf16Offset: newIndex, in: parent)
    }
    
}

extension StringProtocol {
    
    var firstIndex: String.Index {
        String.Index(utf16Offset: 0, in: self)
    }
    
    var lastIndex: String.Index {
        String.Index(utf16Offset: self.count - 1, in: self)
    }
    
}
