//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class ParseStringTests: XCTestCase {
  struct TestConvertible: CustomStringConvertible {
    static let stringRepresentation = "stringRepresentation"

    var description: String {
      return TestConvertible.stringRepresentation
    }
  }

  struct TestNotConvertible {}

  func testParseString_WithStringArgument() throws {
    let value = try Filters.parseString(from: ["foo"])
    XCTAssertEqual(value, "foo")
  }

  func testParseString_WithStringConvertableArgument() throws {
    let value = try Filters.parseString(from: [TestConvertible()])
    XCTAssertEqual(value, TestConvertible.stringRepresentation)
  }

  func testParseEnum_WithNonStringConvertableArgument() throws {
    XCTAssertThrowsError(try Filters.parseString(from: [TestNotConvertible()]))
  }

  func testParseEnum_WithEmptyArray() throws {
    XCTAssertThrowsError(try Filters.parseString(from: []))
  }

  func testParseEnum_WithNonZeroIndex() throws {
    let value = try Filters.parseString(from: [TestNotConvertible(), TestConvertible()], at: 1)
    XCTAssertEqual(value, TestConvertible.stringRepresentation)
  }
}
