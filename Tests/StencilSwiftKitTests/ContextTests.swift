//
// StencilSwiftKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import StencilSwiftKit
import XCTest

class ContextTests: XCTestCase {
  func testEmpty() throws {
    let context = [String: Any]()

    let result = try StencilContext.enrich(
      context: context,
      parameters: [],
      environment: ["PATH": "foo:bar:baz"]
    )
    XCTAssertEqual(result.count, 2, "2 items have been added")

    guard let env = result[StencilContext.environmentKey] as? [String: Any] else {
      XCTFail("`env` should be a dictionary")
      return
    }
    XCTAssertEqual(env["PATH"] as? String, "foo:bar:baz")

    guard let params = result[StencilContext.parametersKey] as? [String: Any] else {
      XCTFail("`param` should be a dictionary")
      return
    }
    XCTAssertEqual(params.count, 0)
  }

  func testWithContext() throws {
    let context: [String: Any] = ["foo": "bar", "hello": true]

    let result = try StencilContext.enrich(
      context: context,
      parameters: [],
      environment: ["PATH": "foo:bar:baz"]
    )
    XCTAssertEqual(result.count, 4, "4 items have been added")
    XCTAssertEqual(result["foo"] as? String, "bar")
    XCTAssertEqual(result["hello"] as? Bool, true)

    guard let env = result[StencilContext.environmentKey] as? [String: Any] else {
      XCTFail("`env` should be a dictionary")
      return
    }
    XCTAssertEqual(env["PATH"] as? String, "foo:bar:baz")

    guard let params = result[StencilContext.parametersKey] as? [String: Any] else {
      XCTFail("`param` should be a dictionary")
      return
    }
    XCTAssertEqual(params.count, 0)
  }

  func testWithParameters() throws {
    let context = [String: Any]()

    let result = try StencilContext.enrich(
      context: context,
      parameters: ["foo=bar", "hello"],
      environment: ["PATH": "foo:bar:baz"]
    )
    XCTAssertEqual(result.count, 2, "2 items have been added")

    guard let env = result[StencilContext.environmentKey] as? [String: Any] else {
      XCTFail("`env` should be a dictionary")
      return
    }
    XCTAssertEqual(env["PATH"] as? String, "foo:bar:baz")

    guard let params = result[StencilContext.parametersKey] as? [String: Any] else {
      XCTFail("`param` should be a dictionary")
      return
    }
    XCTAssertEqual(params["foo"] as? String, "bar")
    XCTAssertEqual(params["hello"] as? Bool, true)
  }
}
