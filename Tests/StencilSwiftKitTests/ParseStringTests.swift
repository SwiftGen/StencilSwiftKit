//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import StencilSwiftKit
import XCTest

final class ParseStringTests: XCTestCase {
  private struct TestLosslessConvertible: LosslessStringConvertible {
    static let stringRepresentation = "TestLosslessConvertibleStringRepresentation"

    var description: String {
      Self.stringRepresentation
    }

    init() {}
    init?(_ description: String) {}
  }

  private struct TestConvertible: CustomStringConvertible {
    static let stringRepresentation = "TestConvertibleStringRepresentation"

    var description: String {
      Self.stringRepresentation
    }
  }

  private struct TestNotConvertible {}

  // swiftlint:disable legacy_objc_type
  func testParseString_FromValue_WithNSStringValue() throws {
    let value = try Filters.parseString(from: NSString(string: "foo"))
    XCTAssertEqual(value, "foo")
  }
  // swiftlint:enable legacy_objc_type

  func testParseString_FromValue_WithStringValue() throws {
    let value = try Filters.parseString(from: "foo")
    XCTAssertEqual(value, "foo")
  }

  func testParseString_FromValue_WithNil() throws {
    XCTAssertThrowsError(try Filters.parseString(from: nil))
  }

  func testParseString_FromValue_WithStringLosslessConvertableArgument() throws {
    let value = try Filters.parseString(from: TestLosslessConvertible())
    XCTAssertEqual(value, TestLosslessConvertible.stringRepresentation)
  }

  func testParseString_FromValue_WithStringConvertableArgument() throws {
    XCTAssertThrowsError(try Filters.parseString(from: TestConvertible()))
  }

  func testParseString_FromValue_WithNonStringConvertableArgument() throws {
    XCTAssertThrowsError(try Filters.parseString(from: TestNotConvertible()))
  }

  func testParseStringArgument_WithStringArgument() throws {
    let value = try Filters.parseStringArgument(from: ["foo"])
    XCTAssertEqual(value, "foo")
  }

  func testParseStringArgument_WithStringLosslessConvertableArgument() throws {
    let value = try Filters.parseStringArgument(from: [TestLosslessConvertible()])
    XCTAssertEqual(value, TestLosslessConvertible.stringRepresentation)
  }

  func testParseStringArgument_WithStringConvertableArgument() throws {
    XCTAssertThrowsError(try Filters.parseStringArgument(from: [TestConvertible()]))
  }

  func testParseStringArgument_WithNonStringConvertableArgument() throws {
    XCTAssertThrowsError(try Filters.parseStringArgument(from: [TestNotConvertible()]))
  }

  func testParseStringArgument_WithEmptyArray() throws {
    XCTAssertThrowsError(try Filters.parseStringArgument(from: []))
  }

  func testParseStringArgument_WithNonZeroIndex() throws {
    let arguments = [TestNotConvertible(), TestLosslessConvertible(), TestConvertible()] as [Any]
    let value = try Filters.parseStringArgument(from: arguments, at: 1)
    XCTAssertEqual(value, TestLosslessConvertible.stringRepresentation)
  }
}
