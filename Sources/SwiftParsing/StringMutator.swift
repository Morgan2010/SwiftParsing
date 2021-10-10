//
//  File.swift
//  File
//
//  Created by Morgan McColl on 11/10/21.
//

import Foundation

public struct StringMutator {
    
    var indentString: String = "    "
    
    public init(indentString: String = "    ") {
        self.indentString = indentString
    }
    
    public func createBlock(for str: String, indent amount: Int = 0) -> String {
        indentLines(data: "{\n" + indentLines(data: str) + "\n}", amount: amount)
    }
    
    public func indent(data: String, amount: Int = 1) -> String {
        guard amount > 0 else {
            return data
        }
        let indentStringTotal = String(repeating: indentString, count: amount)
        return indentStringTotal + data
    }
    
    public func indentLines(data: String, amount: Int = 1) -> String {
        guard amount > 0 else {
            return data
        }
        let lines = data.components(separatedBy: .newlines)
        let indentedLines = lines.map { indent(data: $0, amount: amount) }
        return indentedLines.reduce("") { joinWithNewLines(str1: $0, str2: $1) }
    }
    
    public func joinWithNewLines(str1: String, str2: String, amount: Int = 1) -> String {
        guard amount > 0 else {
            return str1 + str2
        }
        if str1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return str2
        }
        if str2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return str1
        }
        let newLines = String(repeating: "\n", count: amount)
        return str1 + newLines + str2
    }
    
    public func removeRedundentIndentation(data: String) -> String {
        guard let minIndent = (data.compactMap { countWhitespaceAtFront(of: String($0)) }).min() else {
            return data
        }
        let redundentIndent = (minIndent / indentString.count) * indentString.count
        let components = data.components(separatedBy: .newlines)
        let sanitisedLines = components.map { $0.dropFirst(redundentIndent) }
        return sanitisedLines.reduce("") { joinWithNewLines(str1: $0, str2: String($1)) }
    }
    
    private func countWhitespaceAtFront(of data: String) -> Int? {
        guard let count = data.firstIndex(where: { $0 != "\n" || $0 != " " || $0 != "\0" || $0 != "\r" || $0 != "\t" }) else {
            return nil
        }
        return count.utf16Offset(in: data) + 1
    }
    
}
