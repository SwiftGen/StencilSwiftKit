//
// StencilSwiftKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import Stencil
@testable import StencilSwiftKit
import XCTest

class MapNodeTests: XCTestCase {
  static let context = [
    "items": ["one", "two", "three"]
  ]

  func testParserFilterExpression() {
    let tokens: [Token] = [
      .block(value: "map items into result", at: .unknown),
      .text(value: "hello", at: .unknown),
      .block(value: "endmap", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MapNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    switch node.resolvable {
    case let reference as FilterExpression:
      XCTAssertEqual(reference.variable.variable, "items")
    default:
      XCTFail("Unexpected resolvable type")
    }
    XCTAssertNil(node.mapVariable)
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }

  func testParserRange() {
    let tokens: [Token] = [
      .block(value: "map 1...3 into result", at: .unknown),
      .text(value: "hello", at: .unknown),
      .block(value: "endmap", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MapNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    switch node.resolvable {
    case is RangeVariable:
      break
    default:
      XCTFail("Unexpected resolvable type")
    }
    XCTAssertNil(node.mapVariable)
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }

  func testParserWithMapVariable() {
    let tokens: [Token] = [
      .block(value: "map items into result using item", at: .unknown),
      .text(value: "hello", at: .unknown),
      .block(value: "endmap", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MapNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    XCTAssertEqual(node.resultName, "result")
    XCTAssertEqual(node.mapVariable, "item")
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }

  func testParserFail() {
    // no closing tag
    do {
      let tokens: [Token] = [
        .block(value: "map items into result", at: .unknown),
        .text(value: "hello", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }

    // no parameters
    do {
      let tokens: [Token] = [
        .block(value: "map", at: .unknown),
        .text(value: "hello", at: .unknown),
        .block(value: "endmap", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }

    // no result parameters
    do {
      let tokens: [Token] = [
        .block(value: "map items", at: .unknown),
        .text(value: "hello", at: .unknown),
        .block(value: "endmap", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }

    // no result variable name
    do {
      let tokens: [Token] = [
        .block(value: "map items into", at: .unknown),
        .text(value: "hello", at: .unknown),
        .block(value: "endmap", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }

    // no map variable name
    do {
      let tokens: [Token] = [
        .block(value: "map items into result using", at: .unknown),
        .text(value: "hello", at: .unknown),
        .block(value: "endmap", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  func testRender() throws {
    let context = Context(dictionary: MapNodeTests.context)
    let node = MapNode(
      resolvable: Variable("items"),
      resultName: "result",
      mapVariable: nil,
      nodes: [TextNode(text: "hello")]
    )
    let output = try node.render(context)

    XCTAssertEqual(output, "")
  }

  func testContext() throws {
    let context = Context(dictionary: MapNodeTests.context)
    let node = MapNode(
      resolvable: Variable("items"),
      resultName: "result",
      mapVariable: "item",
      nodes: [TextNode(text: "hello")]
    )
    _ = try node.render(context)

    guard let items = context["items"] as? [String], let result = context["result"] as? [String] else {
      XCTFail("Unable to render map")
      return
    }
    XCTAssertEqual(items, MapNodeTests.context["items"] ?? [])
    XCTAssertEqual(result, ["hello", "hello", "hello"])
  }

  func testMapLoopContext() throws {
    let context = Context(dictionary: MapNodeTests.context)
    let node = MapNode(
      resolvable: Variable("items"),
      resultName: "result",
      mapVariable: nil,
      nodes: [
        VariableNode(variable: "maploop.counter"),
        VariableNode(variable: "maploop.first"),
        VariableNode(variable: "maploop.last"),
        VariableNode(variable: "maploop.item")
      ]
    )
    _ = try node.render(context)

    guard let items = context["items"] as? [String], let result = context["result"] as? [String] else {
      XCTFail("Unable to render map")
      return
    }
    XCTAssertEqual(items, MapNodeTests.context["items"] ?? [])
    XCTAssertEqual(result, ["0truefalseone", "1falsefalsetwo", "2falsetruethree"])
  }
}
