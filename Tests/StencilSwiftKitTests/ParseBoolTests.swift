//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import StencilSwiftKit
import XCTest

final class ParseBoolTests: XCTestCase {
  func testParseBool_TrueWithString() throws {
    XCTAssertEqual(try Filters.parseBool(from: ["true"]), .some(true))
    XCTAssertEqual(try Filters.parseBool(from: ["yes"]), .some(true))
    XCTAssertEqual(try Filters.parseBool(from: ["1"]), .some(true))
  }

  func testParseBool_FalseWithString() throws {
    XCTAssertEqual(try Filters.parseBool(from: ["false"]), .some(false))
    XCTAssertEqual(try Filters.parseBool(from: ["no"]), .some(false))
    XCTAssertEqual(try Filters.parseBool(from: ["0"]), .some(false))
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
    XCTAssertEqual(try Filters.parseBool(from: ["test", "true"], at: 1), .some(true))
    XCTAssertEqual(try Filters.parseBool(from: ["test", "false"], at: 1), .some(false))
  }
}
