//
// StencilSwiftKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import Stencil
@testable import StencilSwiftKit
import XCTest

class ImportNodeTests: XCTestCase {
  func testParser() {
    let tokens: [Token] = [
      .block(value: "import \"Macros.stencil\"", at: .unknown)
    ]

    let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
    guard let nodes = try? parser.parse(),
      let node = nodes.first as? ImportNode else {
        XCTFail("Unable to parse tokens")
        return
    }

    XCTAssertEqual(node.templateName.variable, "\"Macros.stencil\"")
  }

  func testParserFail() {
    do {
      let tokens: [Token] = [
        .block(value: "import", at: .unknown)
      ]

      let parser = TokenParser(tokens: tokens, environment: stencilSwiftEnvironment())
      XCTAssertThrowsError(try parser.parse())
    }
  }

  private final class LoaderMock: Loader {
    var loadtemplateCalledWithName: String?
    var loadtemplateCalledWithEnvironment: Environment?
    var loadTemplateResult: Template?
    var loadTemplateError: Error?

    func loadTemplate(name: String, environment: Environment) throws -> Template {
      loadtemplateCalledWithName = name
      loadtemplateCalledWithEnvironment = environment
      if let result = loadTemplateResult {
        return result
      } else if let error = loadTemplateError {
        throw error
      }
      return Template(stringLiteral: "")
    }
  }

  func testRender() throws {
    let loader = LoaderMock()
    let environment = Environment(loader: loader, extensions: nil, templateClass: StencilSwiftTemplate.self)

    let context = Context(environment: environment)
    let node = ImportNode(templateName: Variable("\"Macros.stencil\""))
    let output = try node.render(context)

    XCTAssertEqual(output, "")
    XCTAssertEqual(loader.loadtemplateCalledWithName, "Macros.stencil")
  }

  func testRenderLoaderFail() {
    let loader = LoaderMock()
    let environment = Environment(loader: loader, extensions: nil, templateClass: StencilSwiftTemplate.self)

    let context = Context(environment: environment)
    let node = ImportNode(templateName: Variable("\"Macros.stencil\""))
    let someLoaderError = TemplateDoesNotExist(templateNames: ["Macros.stencil"])
    loader.loadTemplateError = someLoaderError

    XCTAssertThrowsError(try node.render(context), "") { error in
      guard error as? TemplateDoesNotExist != nil else {
        XCTFail(error.localizedDescription)
        return
      }
    }
  }

  func testRenderParamterFail() throws {
    let loader = LoaderMock()
    let environment = Environment(loader: loader, extensions: nil, templateClass: StencilSwiftTemplate.self)

    let context = Context(environment: environment)
    let node = ImportNode(templateName: Variable("a"))

    XCTAssertThrowsError(try node.render(context), "") { error in
      guard error as? TemplateSyntaxError != nil else {
        XCTFail(error.localizedDescription)
        return
      }
    }
  }
}
