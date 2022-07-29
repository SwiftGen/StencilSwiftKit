//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

@testable import Stencil
@testable import StencilSwiftKit
import XCTest

final class ImportNodeTests: XCTestCase {
  func testParser() {
    let tokens: [Token] = [.block(value: "import \"Common.stencil\"", at: .unknown)]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? ImportNode else {
      XCTFail("Unable to parse tokens")
      return
    }

    XCTAssertEqual(node.templateName, Variable("\"Common.stencil\""))
  }

  func testParserFail() {
    do {
      let tokens: [Token] = [.block(value: "import", at: .unknown)]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  func testRenderIsEmpty() throws {
    let node = ImportNode(templateName: Variable("\"Common.stencil\""))
    let env = stencilSwiftEnvironment(templates: ["Common.stencil": "Hello world!"])
    let context = Context(dictionary: ["": ""], environment: env)
    let output = try node.render(context)

    XCTAssertEqual(output, "")
  }

  func testContextModification() throws {
    let node = ImportNode(templateName: Variable("\"Common.stencil\""))
    let env = stencilSwiftEnvironment(templates: ["Common.stencil": "{% set x %}hello{% endset %}"])
    let context = Context(dictionary: ["": ""], environment: env)
    _ = try node.render(context)

    guard let string = context["x"] as? String else {
      XCTFail("Unable to render import token")
      return
    }
    XCTAssertEqual(string, "hello")
  }
}
