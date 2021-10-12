//
//  File.swift
//  File
//
//  Created by Morgan McColl on 12/10/21.
//

import Foundation
import XCTest
@testable import SwiftParsing

final class StringMutatorTests: XCTestCase {
    
    func testCreateBlock() {
        let data = "A"
        let expected = "{\n    \(data)\n}"
        let result = data.createBlock()
        XCTAssertEqual(result, expected)
    }
    
    func testCreateBlockAddsMultipleIndents() {
        let result = "AB".createBlock(indent: 2)
        XCTAssertEqual(result, "{\n        AB\n}")
    }
    
    func testCreateBlockIndentsOnceForNegativeAmount() {
        let result = "A".createBlock(indent: -1)
        XCTAssertEqual(result, "{\n    A\n}")
    }
    
    func testIndent() {
        let result = "A".indent
        XCTAssertEqual(result, "    A")
    }
    
    func testIndentAddsMultipleIndents() {
        let result = "AB".indent(amount: 2)
        XCTAssertEqual(result, "        AB")
    }
    
    func testIndentDoesntIndentForNegativeAmount() {
        let result = "AB".indent(amount: -1)
        XCTAssertEqual(result, "AB")
    }
    
    func testIndentLines() {
        let result = "A\nB".indentLines
        XCTAssertEqual(result, "    A\n    B")
    }
    
    func testIndentLinesAddsMultipleIndents() {
        let result = "A\nB".indentLines(amount: 2)
        XCTAssertEqual(result, "        A\n        B")
    }
    
    func testIndentLinesDoesntIndentForNegativeAmount() {
        let result = "A\nB".indentLines(amount: -1)
        XCTAssertEqual(result, "A\nB")
    }
    
    func testRemoveRedundentIndentation() {
        let result = "    A\n     B".removeRedundentIndentation
        XCTAssertEqual(result, "A\n B")
    }
    
    func testRemoveRedundentIndentationForNonWhitespaceStringReturnsOriginal() {
        let result = "ABC".removeRedundentIndentation
        XCTAssertEqual(result, "ABC")
    }
    
    func testJoinWithNewLines() {
        let result = "A".joinWithNewLines(str2: "B")
        XCTAssertEqual(result, "A\nB")
    }
    
    func testJoinWithNewLinesDoesntAddNewLineForEmptySelf() {
        let result = "".joinWithNewLines(str2: "B")
        XCTAssertEqual(result, "B")
    }
    
    func testJoinWithNewLinesDoesntAddNewLineForEmptyStr2() {
        let result = "A".joinWithNewLines(str2: "")
        XCTAssertEqual(result, "A")
    }
    
    func testJoinWithNewLinesDoesntAddNewLineForNegativeAmount() {
        let result = "A".joinWithNewLines(str2: "B", amount: -1)
        XCTAssertEqual(result, "AB")
    }
    
    func testJoinWithNewLinesAddsMultipleNewLines() {
        let result = "A".joinWithNewLines(str2: "B", amount: 3)
        XCTAssertEqual(result, "A\n\n\nB")
    }
    
}
