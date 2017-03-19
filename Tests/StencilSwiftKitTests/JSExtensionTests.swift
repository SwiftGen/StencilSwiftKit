//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
import StencilSwiftKit

class JSExtensionTests: XCTestCase {

  func template(_ templateString: String,
                _ configuringExtension: (JSExtension) throws -> Void) rethrows -> StencilSwiftTemplate {
    let ext = JSExtension()
    try configuringExtension(ext)
    let env = stencilSwiftEnvironment(extensions: [ext])
    return StencilSwiftTemplate(templateString: templateString, environment: env)
  }
  func render(_ templateString: String,
              context: [String: Any] = [:],
              configuringExtension: (JSExtension) throws -> Void) -> String {
    guard let template = try? self.template(templateString, configuringExtension) else {
      XCTFail("Unable to create template")
      return ""
    }
    guard let result = try? template.render(context) else {
      XCTFail("Unable to render template")
      return ""
    }
    return result
  }

  func testJSFilter() {
    let result = self.render("{{ \"hello\"|jsuppercase }}") { ext in
      let script = "var jsuppercase = function(value, params) { return value.toUpperCase() }"
      ext.registerFilter("jsuppercase", script: script)
    }
    XCTDiffStrings(result, "HELLO")
  }

  func testJSFilterWithArguments() {
    let result = self.render("{{ x|jsjoin:\", \" }}", context: ["x": ["Hello", "World!"]]) { ext in
      let script = "var jsjoin = function(value, params) { return value.join(params[0]) }"
      ext.registerFilter("jsjoin", script: script)
    }
    XCTDiffStrings(result, "Hello, World!")
  }

  func testJSSimpleTag() {
    let result = self.render("{% jshello %}", context: ["name": "World"]) { ext in
      let script = "var jshello = function(context) { return \"Hello, \" + context.valueForKey('name') }"
      ext.registerSimpleTag("jshello", script: script)
    }
    XCTDiffStrings(result, "Hello, World")
  }

  func testJSTag() {
    let template = "{% greet name|capitalize %}Hello, {{ name }}{% endgreet %}"
    let result = self.render(template, context: ["name": "world"]) { ext in
      let script = "function greet(parser, token) { " +
      "var bits = token.components(); if (bits.length != 2) { throw \"'greet' tag takes one argument\" }; " +
      "this.variable = bits[1].split(\"|\")[0]; " +
      "this.nodes = parser.parseUntil([\"endgreet\"], function(e) { throw e }); " +
      "if (parser.nextToken() === null) { throw \"'endgreet' not found\" }; " +
      "this.resolvable = parser.compileFilter(bits[1], function(e) { throw e }); " +
      "this.render = function(context) { " +
      "var resolvable = this.resolvable; var nodes = this.nodes; " +
      "var dict = {}; dict[this.variable] = resolvable.resolve(context, function(e) { throw e }); " +
      "return context.push(dict, function() { return renderNodes(nodes, context, function(e) { throw e }); })" +
      "}}"
      ext.registerTag("greet", script: script)
    }
    XCTDiffStrings(result, "Hello, World")
  }

  func testThatItCatchesJavaScriptExceptions() {
    let message = "This is JS exception"
    do {
      let template = self.template("{% jsthrow %}") { ext in
        ext.registerSimpleTag("jsthrow", script: "function jsthrow(context) { throw context.valueForKey('message') }")
      }
      _ = try template.render(["message": message])
      XCTFail("No exception caught")
    } catch {
      XCTAssertEqual("\(error)", message)
    }
  }

  func testThatItCatchesNativeErrors() {
    do {
      let template = self.template("{% jsthrow %}{% endjsthrow %}") { ext in
        let script = "function jsthrow(parser, token) { parser.parse(); }"
        ext.registerTag("jsthrow", script: script)
      }
      _ = try template.render([:])
      XCTFail("No exception caught")
    } catch {
      XCTAssertEqual("\(error)", "Unknown template tag \'endjsthrow\'")
    }
  }

  func testThatItCanAccessVariable() {
    let value = "value"
    let result = self.render("{% variable %}", context: ["var": value]) { ext in
      let script = "function variable(context) { return new Variable('var').resolve(context) } "
      ext.registerSimpleTag("variable", script: script)
    }
    XCTAssertEqual(result, value)
  }

  func testThatItCanAccessVariableNode() {
    let value = "value"
    let result = self.render("{% variable %}", context: ["var": value]) { ext in
      let script = "function variable(context) " +
      "{ return renderNodes([VariableNode('var'), VariableNode(Variable('var'))], context) }"
      ext.registerSimpleTag("variable", script: script)
    }
    XCTAssertEqual(result, "\(value)\(value)")
  }

  func testThatItCanPushContext() {
    let result = self.render("{% push %}", context: ["level": 0]) { ext in
      let script = "function push(context) " +
      "{ var level = context.valueForKey('level') + 1; return context.push({'level': level}, " +
      "function() { return context.valueForKey('level') }) }"
      ext.registerSimpleTag("push", script: script)
    }
    XCTAssertEqual(result, "1")
  }

  func testThatItCanGetAndSetContextValue() {
    let result = self.render("{% set %}", context: ["level": 0]) { ext in
      let script = "function set(context) " +
      "{ var level = context.valueForKey('level') + 1; context.setValueForKey(level, 'level'); " +
      "return context.valueForKey('level') }"
      ext.registerSimpleTag("set", script: script)
    }
    XCTAssertEqual(result, "1")
  }

  func testThatItCanAccesTokenProperties() {
    let result = self.render("{% token x %}") { ext in
      let script = "function token(parser, token) " +
      "{ this.render = function(context) { return 'components: ' + token.components().join(', ') + '; " +
      "contents: ' + token.contents } }"
      ext.registerTag("token", script: script)
    }
    XCTAssertEqual(result, "components: token, x; contents: token x")
  }

}
