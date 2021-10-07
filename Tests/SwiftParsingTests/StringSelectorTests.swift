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
    
    private var selector: StringSelector?
    
    private var parent: String?
    
    private var correct: String?
    
    private var firstIndex: String.Index {
        parent!.firstIndex
    }
    
    override func setUp() {
        selector = StringSelector()
        parent = "abc$123}{d{ef}g}hi"
        correct = "123"
    }
    
    func testFindSubStringIsValid() {
        XCTAssertNotNil(selector)
        XCTAssertNotNil(parent)
        let result = selector!.findSubString(after: firstIndex, between: "$", and: "}", in: parent!)
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), correct)
    }
    
    func testFindSubStringReturnsNilForInvalidLowerBound() {
        let result = selector!.findSubString(after: firstIndex, between: "!", and: "$", in: parent!)
        XCTAssertNil(result)
    }
    
    func testFindSubStringReturnsNilForInvalidUpperBound() {
        let result = selector!.findSubString(after: firstIndex, between: "$", and: "!", in: parent!)
        XCTAssertNil(result)
    }
    
    func testFindSubStringReturnsNilForInvalidBounds() {
        let result = selector!.findSubString(after: firstIndex, between: "}", and: "$", in: parent!)
        XCTAssertNil(result)
    }
    
    func testFindBalancedSubStringWorksUnderNormalValues() {
        let result = selector!.findSubString(after: firstIndex, between: Set(arrayLiteral: "$"), and: Set(arrayLiteral: "}"), in: parent!)
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), correct!)
    }
    
    func testFindBalancedSubStringNestedValues() {
        let result = selector!.findSubString(after: firstIndex, between: Set(arrayLiteral: "{"), and: Set(arrayLiteral: "}"), in: parent!)
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), "d{ef}g")
    }
    
    func testFindSubStringIsInvalidAfterOnlyCandidate() {
        guard let newIndex = firstIndex.addToIndex(amount: 3, in: parent!) else {
            XCTAssertTrue(false)
            return
        }
        let result = selector!.findSubString(after: newIndex, with: "$", and: "}", in: parent!)
        XCTAssertNil(result)
    }
    
    func testFindSubStringIsStillValidJustBeforeOnlyCandidate() {
        guard let newIndex = firstIndex.addToIndex(amount: 2, in: parent!) else {
            XCTAssertTrue(false)
            return
        }
        let result = selector!.findSubString(after: newIndex, with: "$", and: "}", in: parent!)
        XCTAssertNotNil(result)
        XCTAssertEqual(String(result!.value), correct!)
    }
    
    func testFindSubStringReturnsNilForLastIndex() {
        guard let newIndex = firstIndex.addToIndex(amount: 17, in: parent!) else {
            XCTAssertTrue(false)
            return
        }
        let result = selector!.findSubString(after: newIndex, with: "$", and: "}", in: parent!)
        XCTAssertNil(result)
    }
    
    
}
