//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import Stencil
@testable import StencilSwiftKit
import XCTest

final class MacroNodeTests: XCTestCase {
  func testParser() {
    let tokens: [Token] = [
      .block(value: "macro myFunc", at: .unknown),
      .text(value: "hello", at: .unknown),
      .block(value: "endmacro", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MacroNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.variableName, "myFunc")
    XCTAssertEqual(node.parameters, [])
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }

  func testParserWithParameters() {
    let tokens: [Token] = [
      .block(value: "macro myFunc a b c", at: .unknown),
      .text(value: "hello", at: .unknown),
      .block(value: "endmacro", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MacroNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.variableName, "myFunc")
    XCTAssertEqual(node.parameters, ["a", "b", "c"])
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }

  func testParserFail() {
    do {
      let tokens: [Token] = [
        .block(value: "macro myFunc", at: .unknown),
        .text(value: "hello", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }

    do {
      let tokens: [Token] = [
        .block(value: "macro", at: .unknown),
        .text(value: "hello", at: .unknown),
        .block(value: "endmacro", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  func testRender() throws {
    let node = MacroNode(variableName: "myFunc", parameters: [], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: [:])
    let output = try node.render(context)

    XCTAssertEqual(output, "")
  }

  func testRenderWithParameters() throws {
    let node = MacroNode(variableName: "myFunc", parameters: ["a", "b", "c"], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: [:])
    let output = try node.render(context)

    XCTAssertEqual(output, "")
  }

  func testContextModification() throws {
    let node = MacroNode(variableName: "myFunc", parameters: [], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: ["": ""])
    _ = try node.render(context)

    guard let block = context["myFunc"] as? CallableBlock else {
      XCTFail("Unable to render macro token")
      return
    }
    XCTAssertEqual(block.parameters, [])
    XCTAssertEqual(block.nodes.count, 1)
    XCTAssert(block.nodes.first is TextNode)
  }

  func testContextModificationWithParameters() throws {
    let node = MacroNode(variableName: "myFunc", parameters: ["a", "b", "c"], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: ["": ""])
    _ = try node.render(context)

    guard let block = context["myFunc"] as? CallableBlock else {
      XCTFail("Unable to render macro token")
      return
    }
    XCTAssertEqual(block.parameters, ["a", "b", "c"])
    XCTAssertEqual(block.nodes.count, 1)
    XCTAssert(block.nodes.first is TextNode)
  }

  func testCallableBlockContext() throws {
    let block = CallableBlock(parameters: ["p1", "p2", "p3"], nodes: [TextNode(text: "hello")])
    let arguments = [Variable("a"), Variable("b"), Variable("\"hello\"")]
    let context = Context(dictionary: ["a": 1, "b": 2])

    let result = try block.context(context, arguments: arguments, variable: Variable("myFunc"))
    XCTAssertEqual(result["p1"] as? Int, 1)
    XCTAssertEqual(result["p2"] as? Int, 2)
    XCTAssertEqual(result["p3"] as? String, "hello")
  }

  func testCallableBlockWithFilterExpressionParameter() throws {
    let block = CallableBlock(parameters: ["greeting"], nodes: [])

    let environment = stencilSwiftEnvironment()
    let arguments = try [FilterExpression(token: "greet|uppercase", environment: environment)]
    let context = Context(dictionary: ["greet": "hello"])

    let result = try block.context(context, arguments: arguments, variable: Variable("myFunc"))
    XCTAssertEqual(result["greeting"] as? String, "HELLO")
  }
}
