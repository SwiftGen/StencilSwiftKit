//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class ParseBoolTests: XCTestCase {

  func testParseBool_WithTrueString() throws {
    let value = try Filters.parseBool(from: ["true"])
    XCTAssertTrue(value!)
  }

  func testParseBool_WithFalseString() throws {
    let value = try Filters.parseBool(from: ["false"])
    XCTAssertFalse(value!)
  }

  func testParseBool_WithYesString() throws {
    let value = try Filters.parseBool(from: ["yes"])
    XCTAssertTrue(value!)
  }

  func testParseBool_WithNoString() throws {
    let value = try Filters.parseBool(from: ["no"])
    XCTAssertFalse(value!)
  }

  func testParseBool_WithOneString() throws {
    let value = try Filters.parseBool(from: ["1"])
    XCTAssertTrue(value!)
  }

  func testParseBool_WithZeroString() throws {
    let value = try Filters.parseBool(from: ["0"])
    XCTAssertFalse(value!)
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
}
