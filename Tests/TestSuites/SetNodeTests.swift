//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class SetNodeTests: XCTestCase {
  func testBasic() {
    let template = SwiftTemplate(templateString: Fixtures.string(for: "set-basic.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render([:])
    
    let expected = Fixtures.string(for: "set-basic.out")
    XCTDiffStrings(result, expected)
  }
  
  func testWithContext() {
    let template = SwiftTemplate(templateString: Fixtures.string(for: "set-with-context.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render([
      "x": 1,
      "y": 2,
      "items": [1, 2, 3]
    ])
    
    let expected = Fixtures.string(for: "set-with-context.out")
    XCTDiffStrings(result, expected)
  }
}
