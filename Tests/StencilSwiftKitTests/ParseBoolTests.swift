//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class ParseBoolTests: XCTestCase {

  func testParseBool_TrueWithString() throws {
    XCTAssertTrue(try Filters.parseBool(from: ["true"])!)
    XCTAssertTrue(try Filters.parseBool(from: ["yes"])!)
    XCTAssertTrue(try Filters.parseBool(from: ["1"])!)
  }

  func testParseBool_FalseWithString() throws {
    XCTAssertFalse(try Filters.parseBool(from: ["false"])!)
    XCTAssertFalse(try Filters.parseBool(from: ["no"])!)
    XCTAssertFalse(try Filters.parseBool(from: ["0"])!)
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
    XCTAssertTrue(try Filters.parseBool(from: ["test", "true"], at: 1)!)
    XCTAssertFalse(try Filters.parseBool(from: ["test", "false"], at: 1)!)
  }
}
