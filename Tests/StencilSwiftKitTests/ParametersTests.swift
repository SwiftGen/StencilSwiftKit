//
// ParametersTests.swift
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
import StencilSwiftKit

class ParametersTests: XCTestCase {
  func testBasic() {
    let items = ["a=1", "b=hello", "c=x=y", "d"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 4, "4 parameters should have been parsed")
    XCTAssertEqual(result["a"] as? String, "1")
    XCTAssertEqual(result["b"] as? String, "hello")
    XCTAssertEqual(result["c"] as? String, "x=y")
    XCTAssertEqual(result["d"] as? Bool, true)
  }
  
  func testStructured() {
    let items = ["foo.baz=1", "foo.bar=2"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String: String] else { XCTFail("Parsed parameter should be a dictionary"); return }
    XCTAssertEqual(sub["baz"], "1")
    XCTAssertEqual(sub["bar"], "2")
  }
  
  func testDeepStructured() {
    let items = ["foo.bar.baz.qux=1"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let foo = result["foo"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    guard let bar = foo["bar"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    guard let baz = bar["baz"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    guard let qux = baz["qux"] as? String else { XCTFail("Parsed parameter should be a string"); return }
    XCTAssertEqual(qux, "1")
  }
  
  func testRepeated() {
    let items = ["foo=1", "foo=2", "foo=hello"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String] else { XCTFail("Parsed parameter should be an array"); return }
    XCTAssertEqual(sub.count, 3, "Array has 3 elements")
    XCTAssertEqual(sub[0], "1")
    XCTAssertEqual(sub[1], "2")
    XCTAssertEqual(sub[2], "hello")
  }
  
  func testInvalidSyntax() {
    do {
      let items = ["foo:1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    do {
      let items = ["foo!1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    do {
      let items = [""]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
  }
  
  func testInvalidKey() {
    do {
      let items = ["foo:bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    do {
      let items = [".=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    do {
      let items = ["foo.=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
  }
  
  func testInvalidStructure() {
    do {
      let items = ["foo=1", "foo.bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    do {
      let items = ["foo.bar=1", "foo=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    do {
      let items = ["foo=1", "foo=2", "foo.bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
  }
}
