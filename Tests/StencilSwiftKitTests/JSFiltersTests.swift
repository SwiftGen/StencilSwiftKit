//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
import StencilSwiftKit

class JSFiltersTests: XCTestCase {
  
  func testJSFilter() {
    let ext = JSExtension()
    ext.registerFilter("jsuppercase", script: "var jsuppercase = function(value, params) { return value.toUpperCase() }")
    
    let template = StencilSwiftTemplate(templateString: "{{ \"hello\"|jsuppercase }}", environment: stencilSwiftEnvironment(extensions: [ext]))
    let result = try! template.render([:])
    
    XCTDiffStrings(result, "HELLO")
  }
  
  func testJSFilterWithArguments() {
    let ext = JSExtension()
    ext.registerFilter("jsjoin", script: "var jsjoin = function(value, params) { return value.join(params[0]) }")

    let template = StencilSwiftTemplate(templateString: "{{ x|jsjoin:\", \" }}", environment: stencilSwiftEnvironment(extensions: [ext]))
    let result = try! template.render(["x": ["Hello", "World!"]])
    
    XCTDiffStrings(result, "Hello, World!")
  }
  
  func testJSSimpleTag() {
    let ext = JSExtension()
    ext.registerSimpleTag("jshello", script: "var jshello = function(context) { return \"Hello, \" + context.valueForKey('name') }")
    
    let template = StencilSwiftTemplate(templateString: "{% jshello %}", environment: stencilSwiftEnvironment(extensions: [ext]))
    let result = try! template.render(["name": "World"])
    
    XCTDiffStrings(result, "Hello, World")
  }
  
  func testJSTag() {
    let ext = JSExtension()
    let path = Bundle(for: JSFiltersTests.self).path(forResource: "greet-tag", ofType: "js")!
    try! ext.registerTag("greet", script: String(contentsOfFile: path, encoding: .utf8))
    
    let template = StencilSwiftTemplate(templateString: "{% greet name|capitalize %}Hello, {{ name }}{% endgreet %}", environment: stencilSwiftEnvironment(extensions: [ext]))
    let result = try! template.render(["name": "world"])
    
    XCTDiffStrings(result, "Hello, World")
  }
  
}
