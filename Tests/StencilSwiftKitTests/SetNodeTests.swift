//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import Stencil
@testable import StencilSwiftKit

class SetNodeTests: XCTestCase {
  func testParser() {
    let tokens: [Token] = [
      .block(value: "set value"),
      .text(value: "true"),
      .block(value: "endset")
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? SetNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.variableName, "value")
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }

  func testParserFail() {
    let tokens: [Token] = [
      .block(value: "set value"),
      .text(value: "true")
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    XCTAssertThrowsError(try parser.parse())
  }

  func testRender() throws {
    let node = SetNode(variableName: "value", nodes: [TextNode(text: "true")])
    let context = Context(dictionary: [:])
    let output = try node.render(context)

    XCTAssertEqual(output, "")
  }

  func testContextModification() throws {
    // start empty
    let context = Context(dictionary: [:])
    XCTAssertNil(context["a"])
    XCTAssertNil(context["b"])

    // set a
    var node = SetNode(variableName: "a", nodes: [TextNode(text: "hello")])
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertNil(context["b"])

    // set b
    node = SetNode(variableName: "b", nodes: [TextNode(text: "world")])
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? String, "world")

    // modify a
    node = SetNode(variableName: "a", nodes: [TextNode(text: "hi")])
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hi")
    XCTAssertEqual(context["b"] as? String, "world")
  }

  func testWithExistingContext() throws {
    // start with a=1, b=2
    let context = Context(dictionary: ["a": 1, "b": 2])
    XCTAssertEqual(context["a"] as? Int, 1)
    XCTAssertEqual(context["b"] as? Int, 2)

    // set a
    var node = SetNode(variableName: "a", nodes: [TextNode(text: "hello")])
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? Int, 2)

    // set b
    node = SetNode(variableName: "b", nodes: [TextNode(text: "world")])
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? String, "world")
  }

  func testContextPush() throws {
    // start with a=1, b=2
    let context = Context(dictionary: ["a": 1, "b": 2])
    XCTAssertEqual(context["a"] as? Int, 1)
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertNil(context["c"])

    // set a
    var node = SetNode(variableName: "a", nodes: [TextNode(text: "hello")])
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertNil(context["c"])

    // push context level
    try context.push {
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? Int, 2)
      XCTAssertNil(context["c"])

      // set b
      node = SetNode(variableName: "b", nodes: [TextNode(text: "world")])
      _ = try node.render(context)
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? String, "world")
      XCTAssertNil(context["c"])

      // set c
      node = SetNode(variableName: "c", nodes: [TextNode(text: "foo")])
      _ = try node.render(context)
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? String, "world")
      XCTAssertEqual(context["c"] as? String, "foo")
    }

    // after pop
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertNil(context["c"])
  }
}
