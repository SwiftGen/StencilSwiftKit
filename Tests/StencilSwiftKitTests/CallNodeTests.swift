//
// StencilSwiftKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import Stencil
@testable import StencilSwiftKit
import XCTest

class CallNodeTests: XCTestCase {
  func testParser() {
    let tokens: [Token] = [
      .block(value: "call myFunc", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? CallNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.variable.variable, "myFunc")
    XCTAssertEqual(node.arguments.count, 0)
  }

  func testParserWithArgumentsVariable() {
    let tokens: [Token] = [
      .block(value: "call myFunc a b c", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? CallNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.variable.variable, "myFunc")
    let variables = node.arguments.compactMap { $0 as? FilterExpression }.compactMap { $0.variable }
    XCTAssertEqual(variables, [Variable("a"), Variable("b"), Variable("c")])
  }

  func testParserWithArgumentsRange() throws {
    let token: Token = .block(value: "call myFunc 1...3 5...7 9...a", at: .unknown)
    let tokens = [token]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? CallNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    XCTAssertEqual(node.variable.variable, "myFunc")
    let variables = node.arguments.compactMap { $0 as? RangeVariable }
    XCTAssertEqual(variables.count, 3)  // RangeVariable isn't equatable
  }

  func testParserFail() {
    do {
      let tokens: [Token] = [
        .block(value: "call", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  func testRender() throws {
    let block = CallableBlock(parameters: [], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: ["myFunc": block])
    let node = CallNode(variable: Variable("myFunc"), arguments: [])
    let output = try node.render(context)

    XCTAssertEqual(output, "hello")
  }

  func testRenderFail() {
    let context = Context(dictionary: [:])
    let node = CallNode(variable: Variable("myFunc"), arguments: [])

    XCTAssertThrowsError(try node.render(context))
  }

  func testRenderWithParameters() throws {
    let block = CallableBlock(
      parameters: ["a", "b", "c"],
      nodes: [
        TextNode(text: "variables: "),
        VariableNode(variable: "a"),
        VariableNode(variable: "b"),
        VariableNode(variable: "c")
      ]
    )
    let context = Context(dictionary: ["myFunc": block])
    let node = CallNode(
      variable: Variable("myFunc"),
      arguments: [
        Variable("\"hello\""),
        Variable("\"world\""),
        Variable("\"test\"")
      ]
    )
    let output = try node.render(context)

    XCTAssertEqual(output, "variables: helloworldtest")
  }

  func testRenderWithParametersFail() {
    let block = CallableBlock(
      parameters: ["a", "b", "c"],
      nodes: [
        TextNode(text: "variables: "),
        VariableNode(variable: "a"),
        VariableNode(variable: "b"),
        VariableNode(variable: "c")
      ]
    )
    let context = Context(dictionary: ["myFunc": block])

    // must pass arguments
    do {
      let node = CallNode(variable: Variable("myFunc"), arguments: [])
      XCTAssertThrowsError(try node.render(context))
    }

    // not enough arguments
    do {
      let node = CallNode(
        variable: Variable("myFunc"),
        arguments: [
          Variable("\"hello\"")
        ]
      )
      XCTAssertThrowsError(try node.render(context))
    }

    // too many arguments
    do {
      let node = CallNode(
        variable: Variable("myFunc"),
        arguments: [
          Variable("\"hello\""),
          Variable("\"world\""),
          Variable("\"test\""),
          Variable("\"test\"")
        ]
      )
      XCTAssertThrowsError(try node.render(context))
    }
  }
}
