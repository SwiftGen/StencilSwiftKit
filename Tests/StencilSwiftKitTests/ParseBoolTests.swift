//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

@testable import StencilSwiftKit
import XCTest

class ParseBoolTests: XCTestCase {
  func testParseBool_TrueWithString() throws {
    XCTAssertEqual(try Filters.parseBool(from: ["true"]), true)
    XCTAssertEqual(try Filters.parseBool(from: ["yes"]), true)
    XCTAssertEqual(try Filters.parseBool(from: ["1"]), true)
  }

  func testParseBool_FalseWithString() throws {
    XCTAssertEqual(try Filters.parseBool(from: ["false"]), false)
    XCTAssertEqual(try Filters.parseBool(from: ["no"]), false)
    XCTAssertEqual(try Filters.parseBool(from: ["0"]), false)
  }

  func testParseBool_WithOptionalInt() throws {
    let value = try Filters.parseBool(from: [1], required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithRequiredInt() throws {
    XCTAssertThrowsError(try Filters.parseBool(from: [1], required: true))
  }

  func testParseBool_WithOptionalDouble() throws {
    let value = try Filters.parseBool(from: [1.0], required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithRequiredDouble() throws {
    XCTAssertThrowsError(try Filters.parseBool(from: [1.0], required: true))
  }

  func testParseBool_WithEmptyString() throws {
    XCTAssertThrowsError(try Filters.parseBool(from: [""], required: false))
  }

  func testParseBool_WithEmptyStringAndRequiredArg() throws {
    XCTAssertThrowsError(try Filters.parseBool(from: [""], required: true))
  }

  func testParseBool_WithEmptyArray() throws {
    let value = try Filters.parseBool(from: [], required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithEmptyArrayAndRequiredArg() throws {
    XCTAssertThrowsError(try Filters.parseBool(from: [], required: true))
  }

  func testParseBool_WithNonZeroIndex() throws {
    XCTAssertEqual(try Filters.parseBool(from: ["test", "true"], at: 1), true)
    XCTAssertEqual(try Filters.parseBool(from: ["test", "false"], at: 1), false)
  }
}
