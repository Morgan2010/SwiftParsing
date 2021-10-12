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
   
    var mutator: StringMutator!
    
    override func setUp() {
        mutator = StringMutator(indentString: "    ")
    }
    
    func testCreateBlock() {
        let data = "A"
        let expected = "{\n    \(data)\n}"
        let result = mutator.createBlock(for: data)
        XCTAssertEqual(result, expected)
    }
    
}
