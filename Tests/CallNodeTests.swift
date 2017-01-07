//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class CallNodeTests: XCTestCase {
  func testBasic() {
    let template = SwiftTemplate(templateString: Fixtures.string(for: "call-basic.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render([:])
    
    let expected = Fixtures.string(for: "call-basic.out")
    XCTDiffStrings(result, expected)
  }
  
  func testWithRecursion() {
    let template = SwiftTemplate(templateString: Fixtures.string(for: "call-with-recursion.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render([:])
    
    let expected = Fixtures.string(for: "call-with-recursion.out")
    XCTDiffStrings(result, expected)
  }
}
