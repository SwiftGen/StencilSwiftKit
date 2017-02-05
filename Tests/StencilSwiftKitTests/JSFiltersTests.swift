//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
import StencilSwiftKit

class JSFiltersTests: XCTestCase {
  
  func testJSFilter() {
    let template = StencilSwiftTemplate(templateString: "{{ \"hello\"|jsuppercase }}", environment: stencilSwiftEnvironment({ ext in
      ext.registerJSFilter("jsuppercase", code: "var jsuppercase = function(value, params) { return value.toUpperCase() }")
    }))
    let result = try! template.render([:])
    
    XCTDiffStrings(result, "HELLO")
  }
  
  func testJSFilterWithArguments() {
    let template = StencilSwiftTemplate(templateString: "{{ x|jsjoin:\", \" }}", environment: stencilSwiftEnvironment({ ext in
      ext.registerJSFilter("jsjoin", code: "var jsjoin = function(value, params) { return value.join(params[0]) }")
    }))
    let result = try! template.render(["x": ["Hello", "World!"]])
    
    XCTDiffStrings(result, "Hello, World!")
  }
  
  func testJSSimpleTag() {
    let template = StencilSwiftTemplate(templateString: "{% jshello %}", environment: stencilSwiftEnvironment({ ext in
      ext.registerJSSimpleTag("jshello", code: "var jshello = function(context) { return \"Hello, \" + context.valueForKey('name') }")
    }))
    let result = try! template.render(["name": "World"])
    
    XCTDiffStrings(result, "Hello, World")
  }
  
  func testJSTag() {
    let template = StencilSwiftTemplate(templateString: "{% greet name|capitalize %}Hello, {{ name }}{% endgreet %}", environment: stencilSwiftEnvironment({ ext in
      ext.registerJSTag("greet", code: "function greet(parser, token) { var bits = token.components(); if (bits.length != 2) { throw \"'greet' tag takes one argument\" } this.variable = bits[1].split(\"|\")[0]; this.nodes = parser.parse_until([\"endgreet\"]); if (parser.nextToken() === null) { throw \"'endgreet' not found\"}; this.resolvable = parser.compileFilter(bits[1]); this.render = function(context) { var resolvable = this.resolvable; var nodes = this.nodes; var dict = {}; dict[this.variable] = resolvable.resolve(context); return context.push(dict, function() { return renderNodes(nodes, context); }) }}")
    }))
    let result = try! template.render(["name": "world"])
    
    XCTDiffStrings(result, "Hello, World")
  }
  
}
