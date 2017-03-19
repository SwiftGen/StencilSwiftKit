//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
import StencilSwiftKit

class JSExtensionTests: XCTestCase {

  func template(_ templateString: String, _ configuringExtension: (JSExtension) -> Void) -> StencilSwiftTemplate {
    let ext = JSExtension()
    configuringExtension(ext)
    let env = stencilSwiftEnvironment(extensions: [ext])
    return StencilSwiftTemplate(templateString: templateString, environment: env)
  }
  func render(_ templateString: String,
              context: [String: Any] = [:],
              configuringExtension: (JSExtension) -> Void) -> String {
    let template = self.template(templateString, configuringExtension)
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
      let path = Bundle(for: JSExtensionTests.self).path(forResource: "greet-tag", ofType: "js")!
      try? ext.registerTag("greet", script: String(contentsOfFile: path, encoding: .utf8))
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
