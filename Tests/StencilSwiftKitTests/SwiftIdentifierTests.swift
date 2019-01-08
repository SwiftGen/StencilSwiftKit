//
// StencilSwiftKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

@testable import StencilSwiftKit
import XCTest

class SwiftIdentifierTests: XCTestCase {
  func testBasicString() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "Hello"), "Hello")
  }

  func testBasicStringWithForbiddenChars() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "Hello", forbiddenChars: "l"), "HeO")
  }

  func testBasicStringWithForbiddenCharsAndUnderscores() {
    XCTAssertEqual(
      SwiftIdentifier.identifier(from: "Hello", forbiddenChars: "l", replaceWithUnderscores: true),
      "He__O"
    )
  }

  func testSpecialChars() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "This-is-42$hello@world"), "ThisIs42HelloWorld")
  }

  func testKeepUppercaseAcronyms() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "some$URLDecoder"), "SomeURLDecoder")
  }

  func testEmojis() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "some😎🎉emoji"), "Some😎🎉emoji")
  }

  func testEmojis2() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "😎🎉"), "😎🎉")
  }

  func testNumbersFirst() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: "42hello"), "_42hello")
  }

  func testForbiddenChars() {
    XCTAssertEqual(
      SwiftIdentifier.identifier(from: "hello$world^this*contains%a=lot@of<forbidden>chars!does#it/still:work.anyway?"),
      "HelloWorldThisContainsALotOfForbiddenCharsDoesItStillWorkAnyway"
    )
  }

  func testEmptyString() {
    XCTAssertEqual(SwiftIdentifier.identifier(from: ""), "")
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
      "apples.count": "Apples_Count",
      ".SFNSDisplay": "_SFNSDisplay",
      "Show-NavCtrl": "Show_NavCtrl",
      "HEADER_TITLE": "HEADER_TITLE",
      "multiLine\nKey": "MultiLine_Key",
      "foo_bar.baz.qux-yay": "Foo_bar_Baz_Qux_Yay",
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
      "some$URL": "SomeURL",
      "with space": "WithSpace",
      "apples.count": "ApplesCount",
      ".SFNSDisplay": "SFNSDisplay",
      "Show-NavCtrl": "ShowNavCtrl",
      "HEADER_TITLE": "HeaderTitle",
      "multiLine\nKey": "MultiLineKey",
      "foo_bar.baz.qux-yay": "FooBarBazQuxYay",
      "25 Ultra Light": "_25UltraLight",
      "26_extra_ultra_light": "_26ExtraUltraLight",
      "12 @ 34 % 56 + 78 Hello world": "_12345678HelloWorld"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.swiftIdentifier(input, arguments: ["pretty"]) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
