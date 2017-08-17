//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

class SwiftIdentifierTests: XCTestCase {
  func testBasicString() {
    XCTAssertEqual(swiftIdentifier(from: "Hello"), "Hello")
  }

  func testBasicStringWithForbiddenChars() {
    XCTAssertEqual(swiftIdentifier(from: "Hello", forbiddenChars: "l"), "HeO")
  }

  func testBasicStringWithForbiddenCharsAndUnderscores() {
    XCTAssertEqual(swiftIdentifier(from: "Hello", forbiddenChars: "l", replaceWithUnderscores: true), "He__O")
  }

  func testSpecialChars() {
    XCTAssertEqual(swiftIdentifier(from: "This-is-42$hello@world"), "ThisIs42HelloWorld")
  }

  func testKeepUppercaseAcronyms() {
    XCTAssertEqual(swiftIdentifier(from: "some$URLDecoder"), "SomeURLDecoder")
  }

  func testEmojis() {
    XCTAssertEqual(swiftIdentifier(from: "some😎🎉emoji"), "Some😎🎉emoji")
  }

  func testEmojis2() {
    XCTAssertEqual(swiftIdentifier(from: "😎🎉"), "😎🎉")
  }

  func testNumbersFirst() {
    XCTAssertEqual(swiftIdentifier(from: "42hello"), "_42hello")
  }

  func testForbiddenChars() {
    XCTAssertEqual(
      swiftIdentifier(from: "hello$world^this*contains%a=lot@of<forbidden>chars!does#it/still:work.anyway?"),
      "HelloWorldThisContainsALotOfForbiddenCharsDoesItStillWorkAnyway")
  }
}

extension SwiftIdentifierTests {
  func testSwiftIdentifier_WithNoArgsDefaultsToNormal() throws {
    let result = try Filters.Strings.swiftIdentifier("some_test", arguments: []) as? String
    XCTAssertEqual(result, "Some_test")
  }

  func testSwiftIdentifier_WithWrongArgWillThrow() throws {
    do {
      _ = try Filters.Strings.swiftIdentifier("", arguments: ["wrong"])
      XCTFail("Code did succeed while it was expected to fail for wrong option")
    } catch Filters.Error.invalidOption {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }

  func testSwiftIdentifier_WithNormal() throws {
    let expectations = [
      "hello": "Hello",
      "42hello": "_42hello",
      "some$URL": "Some_URL",
      "with space": "With_Space",
      "25 Ultra Light": "_25_Ultra_Light",
      "26_extra_ultra_light": "_26_extra_ultra_light",
      "12 @ 34 % 56 + 78 Hello world": "_12___34___56___78_Hello_World"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.swiftIdentifier(input, arguments: ["normal"]) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testSwiftIdentifier_WithPretty() throws {
    let expectations = [
      "hello": "Hello",
      "42hello": "_42hello",
      "some$URL": "Some_URL",
      "with space": "WithSpace",
      "25 Ultra Light": "_25UltraLight",
      "26_extra_ultra_light": "_26ExtraUltraLight",
      "12 @ 34 % 56 + 78 Hello world": "_12_34_56_78HelloWorld"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.swiftIdentifier(input, arguments: ["pretty"]) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
