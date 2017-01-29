//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import Stencil
@testable import StencilSwiftKit

class MacroNodeTests: XCTestCase {
  func testParser() {
    let tokens: [Token] = [
      .block(value: "macro myFunc"),
      .text(value: "hello"),
      .block(value: "endmacro")
    ]
    
    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(), let _ = nodes.first as? MacroNode else {
      XCTFail("Unable to parse tokens")
      return
    }
  }
  
  func testParserWithParameters() {
    let tokens: [Token] = [
      .block(value: "macro myFunc a b c"),
      .text(value: "hello"),
      .block(value: "endmacro")
    ]
    
    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(), let _ = nodes.first as? MacroNode else {
      XCTFail("Unable to parse tokens")
      return
    }
  }
  
  func testParserFail() {
    let tokens: [Token] = [
      .block(value: "macro myFunc"),
      .text(value: "hello")
    ]
    
    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    XCTAssertThrowsError(try parser.parse())
  }
  
  func testRender() {
    let node = MacroNode(variableName: "myFunc", parameters: [], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: [:])
    let output = try! node.render(context)
    
    XCTAssertEqual(output, "")
  }
  
  func testRenderWithParameters() {
    let node = MacroNode(variableName: "myFunc", parameters: ["a", "b", "c"], nodes: [TextNode(text: "hello")])
    let context = Context(dictionary: [:])
    let output = try! node.render(context)
    
    XCTAssertEqual(output, "")
  }
}
