//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import Stencil
@testable import StencilSwiftKit
import XCTest

final class SetNodeTests: XCTestCase {
  func testParserRenderMode() {
    let tokens: [Token] = [
      .block(value: "set value", at: .unknown),
      .text(value: "true", at: .unknown),
      .block(value: "endset", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? SetNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.variableName, "value")
    switch node.content {
    case .nodes(let nodes):
      XCTAssertEqual(nodes.count, 1)
      XCTAssert(nodes.first is TextNode)
    default:
      XCTFail("Unexpected node content")
    }
  }

  func testParserEvaluateModeVariable() {
    let tokens: [Token] = [
      .block(value: "set value some.variable.somewhere", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? SetNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    XCTAssertEqual(node.variableName, "value")
    switch node.content {
    case .reference(let reference as FilterExpression):
      XCTAssertEqual(reference.variable.variable, "some.variable.somewhere")
    default:
      XCTFail("Unexpected node content")
    }
  }

  func testParserEvaluateModeRange() {
    let tokens: [Token] = [
      .block(value: "set value 1...3", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? SetNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    XCTAssertEqual(node.variableName, "value")
    switch node.content {
    case .reference(_ as RangeVariable):
      break
    default:
      XCTFail("Unexpected node content")
    }
  }

  func testParserFail() {
    do {
      let tokens: [Token] = [
        .block(value: "set value", at: .unknown),
        .text(value: "true", at: .unknown)
      ]
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }

    do {
      let tokens: [Token] = [
        .block(value: "set value true", at: .unknown),
        .text(value: "true", at: .unknown),
        .block(value: "endset", at: .unknown)
      ]
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  func testRender() throws {
    do {
      let node = SetNode(variableName: "value", content: .nodes([TextNode(text: "true")]))
      let context = Context(dictionary: [:])
      let output = try node.render(context)
      XCTAssertEqual(output, "")
    }

    do {
      let node = SetNode(variableName: "value", content: .reference(resolvable: Variable("test")))
      let context = Context(dictionary: [:])
      let output = try node.render(context)
      XCTAssertEqual(output, "")
    }
  }

  func testContextModification() throws {
    // start empty
    let context = Context(dictionary: ["": ""])
    XCTAssertNil(context["a"])
    XCTAssertNil(context["b"])
    XCTAssertNil(context["c"])

    // set a
    var node = SetNode(variableName: "a", content: .nodes([TextNode(text: "hello")]))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertNil(context["b"])
    XCTAssertNil(context["c"])

    // set b
    node = SetNode(variableName: "b", content: .nodes([TextNode(text: "world")]))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertNil(context["c"])

    // modify a
    node = SetNode(variableName: "a", content: .nodes([TextNode(text: "hi")]))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hi")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertNil(context["c"])

    // alias a into c
    node = SetNode(variableName: "c", content: .reference(resolvable: Variable("a")))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hi")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertEqual(context["c"] as? String, "hi")

    // alias non-existing into c
    node = SetNode(variableName: "c", content: .reference(resolvable: Variable("foo")))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hi")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertNil(context["c"])
  }

  func testWithExistingContext() throws {
    // start with a=1, b=2
    let context = Context(dictionary: ["a": 1, "b": 2, "c": 3])
    XCTAssertEqual(context["a"] as? Int, 1)
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertEqual(context["c"] as? Int, 3)

    // set a
    var node = SetNode(variableName: "a", content: .nodes([TextNode(text: "hello")]))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertEqual(context["c"] as? Int, 3)

    // set b
    node = SetNode(variableName: "b", content: .nodes([TextNode(text: "world")]))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertEqual(context["c"] as? Int, 3)

    // alias a into c
    node = SetNode(variableName: "c", content: .reference(resolvable: Variable("a")))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertEqual(context["c"] as? String, "hello")

    // alias non-existing into c
    node = SetNode(variableName: "c", content: .reference(resolvable: Variable("foo")))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? String, "world")
    XCTAssertNil(context["c"])
  }

  func testContextPush() throws {
    // start with a=1, b=2
    let context = Context(dictionary: ["a": 1, "b": 2])
    XCTAssertEqual(context["a"] as? Int, 1)
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertNil(context["c"])

    // set a
    var node = SetNode(variableName: "a", content: .nodes([TextNode(text: "hello")]))
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
      node = SetNode(variableName: "b", content: .nodes([TextNode(text: "world")]))
      _ = try node.render(context)
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? String, "world")
      XCTAssertNil(context["c"])

      // set c
      node = SetNode(variableName: "c", content: .nodes([TextNode(text: "foo")]))
      _ = try node.render(context)
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? String, "world")
      XCTAssertEqual(context["c"] as? String, "foo")
    }

    // after pop
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertNil(context["c"])

    // push context level
    try context.push {
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? Int, 2)
      XCTAssertNil(context["c"])

      // alias a into c
      node = SetNode(variableName: "c", content: .reference(resolvable: Variable("a")))
      _ = try node.render(context)
      XCTAssertEqual(context["a"] as? String, "hello")
      XCTAssertEqual(context["b"] as? Int, 2)
      XCTAssertEqual(context["c"] as? String, "hello")
    }

    // after pop
    XCTAssertEqual(context["a"] as? String, "hello")
    XCTAssertEqual(context["b"] as? Int, 2)
    XCTAssertNil(context["c"])
  }

  func testDifferenceRenderEvaluate() throws {
    // start empty
    let context = Context(dictionary: ["items": [1, 3, 7]])
    XCTAssertNil(context["a"])
    XCTAssertNil(context["b"])

    // set a
    var node = SetNode(variableName: "a", content: .nodes([VariableNode(variable: "items")]))
    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "[1, 3, 7]")
    XCTAssertNil(context["b"])

    // set b
    node = SetNode(variableName: "b", content: .reference(resolvable: Variable("items")))
    _ = try node.render(context)
    XCTAssertEqual(context["b"] as? [Int], [1, 3, 7])
  }

  func testSetWithFilterExpressionParameter() throws {
    let context = Context(dictionary: ["greet": "hello"])

    let environment = stencilSwiftEnvironment()
    let argument = try FilterExpression(token: "greet|uppercase", environment: environment)
    let node = SetNode(variableName: "a", content: .reference(resolvable: argument))

    _ = try node.render(context)
    XCTAssertEqual(context["a"] as? String, "HELLO")
  }
}
