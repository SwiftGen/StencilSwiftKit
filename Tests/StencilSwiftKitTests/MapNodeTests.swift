//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class MapNodeTests: XCTestCase {
  static let context = [
    "items1": ["one", "two", "three"],
    "items2": ["hello", "world", "everyone"]
  ]
  
  func testBasic() {
    let template = StencilSwiftTemplate(templateString: Fixtures.string(for: "map-basic.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(MapNodeTests.context)
    
    let expected = Fixtures.string(for: "map-basic.out")
    XCTDiffStrings(result, expected)
  }
  
  func testWithIndex() {
    let template = StencilSwiftTemplate(templateString: Fixtures.string(for: "map-with-index.stencil"), environment: stencilSwiftEnvironment())
    let result = try! template.render(MapNodeTests.context)

    let expected = Fixtures.string(for: "map-with-index.out")
    XCTDiffStrings(result, expected)
  }
}
