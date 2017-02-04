//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

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
  
}
