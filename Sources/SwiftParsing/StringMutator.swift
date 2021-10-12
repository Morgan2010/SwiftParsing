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
    
    /// Indent the string once
    var indent: String {
        self.indent()
    }
    
    /// Indent all the lines in the string once
    var indentLines: String {
        self.indentLines()
    }
    
    /// Remove all indentation for all lines equally until one line has no indentation.
    var removeRedundentIndentation: String {
        guard let minIndent = self.components(separatedBy: .newlines).compactMap(\.countWhitespaceAtFront).min() else {
            return self
        }
        let redundentIndent = (minIndent / indentString.count) * indentString.count
        let components = self.components(separatedBy: .newlines)
        let sanitisedLines = components.map { $0.dropFirst(redundentIndent) }
        return sanitisedLines.reduce("") { $0.joinWithNewLines(str2: String($1)) }
    }
    
    /// Creates a programming block.
    /// - Parameter amount: The amount of indentation within the block.
    /// - Returns: The new string within a programmign block.
    func createBlock(indent amount: Int = 1) -> String {
        "{\n" + self.indentLines(amount: amount) + "\n}"
    }
    
    /// Indent a string by an amount.
    /// - Parameter amount: The amount to indent.
    /// - Returns: The indented string.
    func indent(amount: Int = 1) -> String {
        guard amount > 0 else {
            return self
        }
        let indentStringTotal = String(repeating: indentString, count: amount)
        return indentStringTotal + self
    }
    
    /// Indent all lines in a string by a specified amount
    /// - Parameter amount: The amount to indent by
    /// - Returns: The string with indented lines.
    func indentLines(amount: Int = 1) -> String {
        guard amount > 0 else {
            return self
        }
        let lines = self.components(separatedBy: .newlines)
        let indentedLines = lines.map { $0.indent(amount: amount) }
        return indentedLines.reduce("") { $0.joinWithNewLines(str2: $1) }
    }
    
    /// Selectively join strings together by placing an amount of new lines between them. Empty Strings are not joined.
    /// - Parameters:
    ///   - str2: The string to append to self.
    ///   - amount: The amount of new lines between the strings.
    /// - Returns: The joined strings.
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
