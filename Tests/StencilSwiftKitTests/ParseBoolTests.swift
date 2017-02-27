//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class ParseBoolTests: XCTestCase {

  func testParseBool_WithTrueString() throws {
    let value = try StringFilters.parseBool(from: ["true"], index: 0)
    XCTAssertTrue(value!)
  }

  func testParseBool_WithFalseString() throws {
    let value = try StringFilters.parseBool(from: ["false"], index: 0)
    XCTAssertFalse(value!)
  }

  func testParseBool_WithYesString() throws {
    let value = try StringFilters.parseBool(from: ["yes"], index: 0)
    XCTAssertTrue(value!)
  }

  func testParseBool_WithNoString() throws {
    let value = try StringFilters.parseBool(from: ["no"], index: 0)
    XCTAssertFalse(value!)
  }

  func testParseBool_WithOneString() throws {
    let value = try StringFilters.parseBool(from: ["1"], index: 0)
    XCTAssertTrue(value!)
  }

  func testParseBool_WithZeroString() throws {
    let value = try StringFilters.parseBool(from: ["0"], index: 0)
    XCTAssertFalse(value!)
  }

  func testParseBool_WithOptionalInt() throws {
    let value = try StringFilters.parseBool(from: [1], index: 0, required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithRequiredInt() throws {
    XCTAssertThrows(try StringFilters.parseBool(from: [1], index: 0, required: true))
  }

  func testParseBool_WithOptionalDouble() throws {
    let value = try StringFilters.parseBool(from: [1.0], index: 0, required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithRequiredDouble() throws {
    XCTAssertThrows(try StringFilters.parseBool(from: [1.0], index: 0, required: true))
  }

  func testParseBool_WithEmptyString() throws {
    let value = try StringFilters.parseBool(from: [""], index: 0, required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithEmptyStringAndRequiredArg() throws {
    XCTAssertThrows(try StringFilters.parseBool(from: [""], index: 0, required: true))
  }

  func testParseBool_WithEmptyArray() throws {
    let value = try StringFilters.parseBool(from: [], index: 0, required: false)
    XCTAssertNil(value)
  }

  func testParseBool_WithEmptyArrayAndRequiredArg() throws {
    XCTAssertThrows(try StringFilters.parseBool(from: [], index: 0, required: true))
  }
}
