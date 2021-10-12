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
    
}
