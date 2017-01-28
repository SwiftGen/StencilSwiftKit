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
      _ = try Parameters.parse(items: items)
    } catch ParametersError.invalidSyntax {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
    
    do {
      let items = ["foo!1"]
      _ = try Parameters.parse(items: items)
    } catch ParametersError.invalidSyntax {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
    
    do {
      let items = [""]
      _ = try Parameters.parse(items: items)
    } catch ParametersError.invalidSyntax {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
  
  func testInvalidKey() {
    do {
      let items = ["foo:bar=1"]
      _ = try Parameters.parse(items: items)
    } catch ParametersError.invalidKey {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
    
    do {
      let items = [".=1"]
      _ = try Parameters.parse(items: items)
    } catch ParametersError.invalidKey {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
    
    do {
      let items = ["foo.=1"]
      _ = try Parameters.parse(items: items)
    } catch ParametersError.invalidKey {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
