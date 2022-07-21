//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import StencilSwiftKit
import XCTest

final class ParseEnumTests: XCTestCase {
  private enum Test: String {
    case foo
    case bar
    case baz
  }

  func testParseEnum_WithFooString() throws {
    let value = try Filters.parseEnum(from: ["foo"], default: Test.baz)
    XCTAssertEqual(value, Test.foo)
  }

  func testParseEnum_WithBarString() throws {
    let value = try Filters.parseEnum(from: ["bar"], default: Test.baz)
    XCTAssertEqual(value, Test.bar)
  }

  func testParseEnum_WithBazString() throws {
    let value = try Filters.parseEnum(from: ["baz"], default: Test.baz)
    XCTAssertEqual(value, Test.baz)
  }

  func testParseEnum_WithEmptyArray() throws {
    let value = try Filters.parseEnum(from: [], default: Test.baz)
    XCTAssertEqual(value, Test.baz)
  }

  func testParseEnum_WithNonZeroIndex() throws {
    let value = try Filters.parseEnum(from: [42, "bar"], at: 1, default: Test.baz)
    XCTAssertEqual(value, Test.bar)
  }

  func testParseEnum_WithUnknownArgument() throws {
    XCTAssertThrowsError(try Filters.parseEnum(from: ["test"], default: Test.baz))
    XCTAssertThrowsError(try Filters.parseEnum(from: [42], default: Test.baz))
  }
}
