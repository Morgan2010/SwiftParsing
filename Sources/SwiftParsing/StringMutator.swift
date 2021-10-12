//
//  File.swift
//  File
//
//  Created by Morgan McColl on 11/10/21.
//

import Foundation

public extension String {
    
    private var indentString: String {
        return "    "
    }
    
    var createBlock: String {
        self.createBlock()
    }
    
    var indent: String {
        self.indent()
    }
    
    var indentLines: String {
        self.indentLines()
    }
    
    var removeRedundentIndentation: String {
        guard let minIndent = self.components(separatedBy: .newlines).compactMap(\.countWhitespaceAtFront).min() else {
            return self
        }
        let redundentIndent = (minIndent / indentString.count) * indentString.count
        let components = self.components(separatedBy: .newlines)
        let sanitisedLines = components.map { $0.dropFirst(redundentIndent) }
        return sanitisedLines.reduce("") { $0.joinWithNewLines(str2: String($1)) }
    }
    
    func createBlock(indent amount: Int = 1) -> String {
        "{\n" + self.indentLines(amount: amount) + "\n}"
    }
    
    func indent(amount: Int = 1) -> String {
        guard amount > 0 else {
            return self
        }
        let indentStringTotal = String(repeating: indentString, count: amount)
        return indentStringTotal + self
    }
    
    func indentLines(amount: Int = 1) -> String {
        guard amount > 0 else {
            return self
        }
        let lines = self.components(separatedBy: .newlines)
        let indentedLines = lines.map { $0.indent(amount: amount) }
        return indentedLines.reduce("") { $0.joinWithNewLines(str2: $1) }
    }
    
    func joinWithNewLines(str2: String, amount: Int = 1) -> String {
        guard amount > 0 else {
            return self + str2
        }
        if self == "" {
            return str2
        }
        if str2 == "" {
            return self
        }
        let newLines = String(repeating: "\n", count: amount)
        return self + newLines + str2
    }
    
    private var countWhitespaceAtFront: Int? {
        guard let count = self.firstIndex(where: {
            guard let uc = $0.unicodeScalars.first else {
                return false
            }
            return !CharacterSet.whitespacesAndNewlines.contains(uc)
        }) else {
            return nil
        }
        return count.utf16Offset(in: self)
    }
    
}
