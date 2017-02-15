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
    let items = ["foo.baz=1", "foo.bar=2", "foo.test"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String: Any] else { XCTFail("Parsed parameter should be a dictionary"); return }
    XCTAssertEqual(sub["baz"] as? String, "1")
    XCTAssertEqual(sub["bar"] as? String, "2")
    XCTAssertEqual(sub["test"] as? Bool, true)
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
    // invalid character
    do {
      let items = ["foo:1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    // invalid character
    do {
      let items = ["foo!1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidSyntax = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    // cannot be empty
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
    // key may only be alphanumeric or '.'
    do {
      let items = ["foo:bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    // can't have empty key or sub-key
    do {
      let items = [".=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidKey = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    // can't have empty sub-key
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
    // can't switch from string to dictionary
    do {
      let items = ["foo=1", "foo.bar=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    // can't switch from dictionary to array
    do {
      let items = ["foo.bar=1", "foo=1"]
      XCTAssertThrowsError(try Parameters.parse(items: items)) {
        guard case ParametersError.invalidStructure = $0 else {
          XCTFail("Unexpected error occured while parsing: \($0)")
          return
        }
      }
    }
    
    // can't switch from array to dictionary
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
