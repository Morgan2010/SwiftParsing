//
//  File.swift
//  File
//
//  Created by Morgan McColl on 8/10/21.
//

import Foundation
import XCTest
@testable import SwiftParsing

final class StringSelectorTests: XCTestCase {
    
    private var parent: String!
    
    private var correct: String!
    
    private var firstIndex: String.Index {
        parent.firstIndex!
    }
    
    override func setUp() {
        parent = "abc$123}{d{ef}g}hi"
        correct = "123"
    }
    
    func testFindSubStringIsValid() {
        let result = parent.findSubString(after: firstIndex, between: "$", and: "}")
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), correct)
    }
    
    func testFindSubStringReturnsNilForInvalidLowerBound() {
        let result = parent.findSubString(after: firstIndex, between: "!", and: "$")
        XCTAssertNil(result)
    }
    
    func testFindSubStringReturnsNilForInvalidUpperBound() {
        let result = parent.findSubString(after: firstIndex, between: "$", and: "!")
        XCTAssertNil(result)
    }
    
    func testFindSubStringReturnsNilForInvalidBounds() {
        let result = parent.findSubString(after: firstIndex, between: "}", and: "$")
        XCTAssertNil(result)
    }
    
    func testFindBalancedSubStringWorksUnderNormalValues() {
        let result = parent.findSubString(after: firstIndex, between: Set(arrayLiteral: "$"), and: Set(arrayLiteral: "}"))
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), correct)
    }
    
    func testFindBalancedSubStringNestedValues() {
        let result = parent.findSubString(after: firstIndex, between: Set(arrayLiteral: "{"), and: Set(arrayLiteral: "}"))
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), "d{ef}g")
    }
    
    func testFindSubStringIsInvalidAfterOnlyCandidate() {
        guard let newIndex = firstIndex.addToIndex(amount: 3, in: parent) else {
            XCTAssertTrue(false)
            return
        }
        let result = parent.findSubString(after: newIndex, with: "$", and: "}")
        XCTAssertNil(result)
    }
    
    func testFindSubStringIsStillValidJustBeforeOnlyCandidate() {
        guard let newIndex = firstIndex.addToIndex(amount: 2, in: parent) else {
            XCTAssertTrue(false)
            return
        }
        let result = parent.findSubString(after: newIndex, with: "$", and: "}")
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), correct)
    }
    
    func testFindSubStringReturnsNilForLastIndex() {
        guard let newIndex = firstIndex.addToIndex(amount: 17, in: parent) else {
            XCTAssertTrue(false)
            return
        }
        let result = parent.findSubString(after: newIndex, with: "$", and: "}")
        XCTAssertNil(result)
    }
    
    func testFindSubStringIsValidForLastIndex() {
        let result = parent.findSubString(after: firstIndex, between: "g", and: "i")
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), "}h")
    }
    
    
}
