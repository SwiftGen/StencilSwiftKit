//
// ParametersTests.swift
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
import StencilSwiftKit

class ParametersTests: XCTestCase {
  func testBasic() {
    let items = ["a=1", "b=hello"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 2, "2 parameters should have been parsed")
    XCTAssertEqual(result["a"] as? String, "1")
    XCTAssertEqual(result["b"] as? String, "hello")
  }
  
  func testStructured() {
    let items = ["foo.baz=1", "foo.bar=2"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String: String] else { XCTFail("Parsed parameter is a dictionary"); return }
    XCTAssertEqual(sub["baz"], "1")
    XCTAssertEqual(sub["bar"], "2")
  }
  
  func testRepeated() {
    let items = ["foo=1", "foo=2", "foo=hello"]
    let result = try! Parameters.parse(items: items)
    
    XCTAssertEqual(result.count, 1, "1 parameter should have been parsed")
    guard let sub = result["foo"] as? [String] else { XCTFail("Parsed parameter is an array"); return }
    XCTAssertEqual(sub.count, 3, "Array has 3 elements")
    XCTAssertEqual(sub[0], "1")
    XCTAssertEqual(sub[1], "2")
    XCTAssertEqual(sub[2], "hello")
  }
}
