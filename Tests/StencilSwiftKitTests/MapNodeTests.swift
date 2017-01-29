//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import Stencil
@testable import StencilSwiftKit

class MapNodeTests: XCTestCase {
  static let context = [
    "items": ["one", "two", "three"]
  ]
  
  func testParser() {
    let tokens: [Token] = [
      .block(value: "map items into result"),
      .text(value: "hello"),
      .block(value: "endmap")
    ]
    
    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MapNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    XCTAssertEqual(node.variable, Variable("items"))
    XCTAssertEqual(node.resultName, "result")
    XCTAssertNil(node.mapVariable)
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }
    
  func testParserWithMapVariable() {
    let tokens: [Token] = [
      .block(value: "map items into result using item"),
      .text(value: "hello"),
      .block(value: "endmap")
    ]
    
    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? MapNode else {
        XCTFail("Unable to parse tokens")
        return
    }
    
    XCTAssertEqual(node.variable, Variable("items"))
    XCTAssertEqual(node.resultName, "result")
    XCTAssertEqual(node.mapVariable, "item")
    XCTAssertEqual(node.nodes.count, 1)
    XCTAssert(node.nodes.first is TextNode)
  }
  
  func testParserFail() {
    // no closing tag
    do {
      let tokens: [Token] = [
        .block(value: "map items into result"),
        .text(value: "hello")
      ]
      
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
    
    // no parameters
    do {
      let tokens: [Token] = [
        .block(value: "map"),
        .text(value: "hello"),
        .block(value: "endmap")
      ]
      
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
    
    // no result parameters
    do {
      let tokens: [Token] = [
        .block(value: "map items"),
        .text(value: "hello"),
        .block(value: "endmap")
      ]
      
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
    
    // no result variable name
    do {
      let tokens: [Token] = [
        .block(value: "map items into"),
        .text(value: "hello"),
        .block(value: "endmap")
      ]
      
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
    
    // no map variable name
    do {
      let tokens: [Token] = [
        .block(value: "map items into result using"),
        .text(value: "hello"),
        .block(value: "endmap")
      ]
      
      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  func testRender() {
    let context = Context(dictionary: MapNodeTests.context)
    let node = MapNode(variable: "items", resultName: "result", mapVariable: nil, nodes: [TextNode(text: "hello")])
    let output = try! node.render(context)
    
    XCTAssertEqual(output, "")
  }
  
  func testContext() {
    let context = Context(dictionary: MapNodeTests.context)
    let node = MapNode(variable: "items", resultName: "result", mapVariable: "item", nodes: [TextNode(text: "hello")])
    _ = try! node.render(context)
    
    guard let items = context["items"] as? [String], let result = context["result"] as? [String] else {
      XCTFail("Unable to render map")
      return
    }
    XCTAssertEqual(items, MapNodeTests.context["items"] ?? [])
    XCTAssertEqual(result, ["hello", "hello", "hello"])
  }
  
  func testMapLoopContext() {
    let context = Context(dictionary: MapNodeTests.context)
    let node = MapNode(variable: "items", resultName: "result", mapVariable: nil, nodes: [
      VariableNode(variable: "maploop.counter"),
      VariableNode(variable: "maploop.first"),
      VariableNode(variable: "maploop.last"),
      VariableNode(variable: "maploop.item")
    ])
    _ = try! node.render(context)
    
    guard let items = context["items"] as? [String], let result = context["result"] as? [String] else {
      XCTFail("Unable to render map")
      return
    }
    XCTAssertEqual(items, MapNodeTests.context["items"] ?? [])
    XCTAssertEqual(result, ["0truefalseone", "1falsefalsetwo", "2falsetruethree"])
  }
}
