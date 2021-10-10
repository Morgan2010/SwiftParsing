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
    
    public func createBlock(for str: String) -> String {
        "{\n" + indentLines(data: str) + "\n}"
    }
    
    public func indent(data: String, amount: Int = 1) -> String {
        let indentStringTotal = String(repeating: indentString, count: amount)
        return indentStringTotal + data
    }
    
    public func indentLines(data: String, amount: Int = 1) -> String {
        let lines = data.components(separatedBy: .newlines)
        let indentedLines = lines.map { indent(data: $0, amount: amount) }
        return indentedLines.reduce("") { joinWithNewLines(str1: $0, str2: $1) }
    }
    
    public func joinWithNewLines(str1: String, str2: String) -> String {
        if str1 == "" {
            return str2
        }
        if str2 == "" {
            return str1
        }
        return str1 + "\n" + str2
    }
    
}
