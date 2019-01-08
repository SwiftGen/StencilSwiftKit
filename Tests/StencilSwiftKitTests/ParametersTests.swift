//
// StencilSwiftKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class ParametersTests: XCTestCase {
  func testBasic() throws {
    let items = ["a=1", "b=hello", "c=x=y", "d"]
    let result = try Parameters.parse(items: items)

    XCTAssertEqual(result.count, 4, "4 parameters should have been parsed")
    XCTAssertEqual(result["a"] as? String, "1")
    XCTAssertEqual(result["b"] as? String, "hello")
    XCTAssertEqual(result["c"] as? String, "x=y")
    XCTAssertEqual(result["d"] as? Bool, true)

    // Test the opposite operation (flatten) as well
    let reverse = Parameters.flatten(dictionary: result)
    XCTAssertEqual(reverse.count, items.count, "Flattening dictionary != original list")
    XCTAssertEqual(Set(reverse), Set(items), "Flattening dictionary != original list")
  }

  func testStructured() throws {
    let items = ["foo.baz=1", "foo.bar=2", "foo.test"]
    let result = try Parameters.parse(items: items)

    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    XCTAssertEqual(sub["baz"] as? String, "1")
    XCTAssertEqual(sub["bar"] as? String, "2")
    XCTAssertEqual(sub["test"] as? Bool, true)

    // Test the opposite operation (flatten) as well
    let reverse = Parameters.flatten(dictionary: result)
    XCTAssertEqual(reverse.count, items.count, "Flattening dictionary != original list")
    XCTAssertEqual(Set(reverse), Set(items), "Flattening dictionary != original list")
  }

  func testDeepStructured() throws {
    let items = ["foo.bar.baz.qux=1"]
    let result = try Parameters.parse(items: items)

    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let foo = result["foo"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    guard let bar = foo["bar"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    guard let baz = bar["baz"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    guard let qux = baz["qux"] as? String else { XCTFail("Parsed parameter should be a string"); return }
    XCTAssertEqual(qux, "1")

    // Test the opposite operation (flatten) as well
    let reverse = Parameters.flatten(dictionary: result)
    XCTAssertEqual(reverse.count, items.count, "Flattening dictionary != original list")
    XCTAssertEqual(Set(reverse), Set(items), "Flattening dictionary != original list")
  }

  func testRepeated() throws {
    let items = ["foo=1", "foo=2", "foo=hello"]
    let result = try Parameters.parse(items: items)

    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String] else { XCTFail("Parsed parameter should be an array"); return }
    XCTAssertEqual(sub.count, 3, "Array has 3 elements")
    XCTAssertEqual(sub[0], "1")
    XCTAssertEqual(sub[1], "2")
    XCTAssertEqual(sub[2], "hello")

    // Test the opposite operation (flatten) as well
    let reverse = Parameters.flatten(dictionary: result)
    XCTAssertEqual(reverse.count, items.count, "Flattening dictionary != original list")
    XCTAssertEqual(Set(reverse), Set(items), "Flattening dictionary != original list")
    XCTAssertEqual(reverse, items, "The order of arrays are properly preserved when flattened")
  }

  func testFlattenBool() {
    let trueFlag = Parameters.flatten(dictionary: ["test": true])
    XCTAssertEqual(trueFlag, ["test"], "True flag is flattened to a param without value")

    let falseFlag = Parameters.flatten(dictionary: ["test": false])
    XCTAssertEqual(falseFlag, [], "False flag is flattened to nothing")

    let stringFlag = Parameters.flatten(dictionary: ["test": "a"])
    XCTAssertEqual(stringFlag, ["test=a"], "Non-boolean flag is flattened to a parameter with value")

    let falseStringFlag = Parameters.flatten(dictionary: ["test": "false"])
    XCTAssertEqual(falseStringFlag, ["test=false"], "Non-boolean flag is flattened to a parameter with value")
  }

  func testParseInvalidSyntax() {
    // invalid character
    do {
      let items = ["foo:1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }

    // invalid character
    do {
      let items = ["foo!1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }

    // cannot be empty
    do {
      let items = [""]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
  }

  func testParseInvalidKey() {
    // key may only be alphanumeric or '.'
    do {
      let items = ["foo:bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }

    // can't have empty key or sub-key
    do {
      let items = [".=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }

    // can't have empty sub-key
    do {
      let items = ["foo.=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
  }

  func testParseInvalidStructure() {
    // can't switch from string to dictionary
    do {
      let items = ["foo=1", "foo.bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }

    // can't switch from dictionary to array
    do {
      let items = ["foo.bar=1", "foo=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }

    // can't switch from array to dictionary
    do {
      let items = ["foo=1", "foo=2", "foo.bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case Parameters.Error.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
  }
}
