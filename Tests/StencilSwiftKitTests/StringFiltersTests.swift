//
// StencilSwiftKit UnitTests
// Copyright © 2022 SwiftGen
// MIT Licence
//

// swiftlint:disable file_length

@testable import StencilSwiftKit
import XCTest

final class StringFiltersTests: XCTestCase {
  private struct Input: LosslessStringConvertible, Hashable {
    let stringRepresentation: String

    init(string: String) {
      self.stringRepresentation = string
    }

    init?(_ description: String) {
      self.stringRepresentation = description
    }

    var description: String {
      stringRepresentation
    }
  }

  func testCamelToSnakeCase_WithNoArgsDefaultsToTrue() throws {
    let result = try Filters.Strings.camelToSnakeCase(Input(string: "StringWithWords"), arguments: []) as? String
    XCTAssertEqual(result, "string_with_words")
  }

  func testCamelToSnakeCase_WithTrue() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "string",
      Input(string: "String"): "string",
      Input(string: "strIng"): "str_ing",
      Input(string: "strING"): "str_ing",
      Input(string: "X"): "x",
      Input(string: "x"): "x",
      Input(string: "SomeCapString"): "some_cap_string",
      Input(string: "someCapString"): "some_cap_string",
      Input(string: "string_with_words"): "string_with_words",
      Input(string: "String_with_words"): "string_with_words",
      Input(string: "String_With_Words"): "string_with_words",
      Input(string: "String_With_WoRds"): "string_with_wo_rds",
      Input(string: "STRing_with_words"): "st_ring_with_words",
      Input(string: "string_wiTH_WOrds"): "string_wi_th_w_ords",
      Input(string: ""): "",
      Input(string: "URLChooser"): "url_chooser",
      Input(string: "UrlChooser"): "url_chooser",
      Input(string: "a__b__c"): "a__b__c",
      Input(string: "__y_z!"): "__y_z!",
      Input(string: "PLEASESTOPSCREAMING"): "pleasestopscreaming",
      Input(string: "PLEASESTOPSCREAMING!"): "pleasestopscreaming!",
      Input(string: "PLEASE_STOP_SCREAMING"): "please_stop_screaming",
      Input(string: "PLEASE_STOP_SCREAMING!"): "please_stop_screaming!"
    ]

    for (input, expected) in expectations {
      let trueArgResult = try Filters.Strings.camelToSnakeCase(input, arguments: ["true"]) as? String
      XCTAssertEqual(trueArgResult, expected)
    }
  }

  func testCamelToSnakeCase_WithFalse() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "string",
      Input(string: "String"): "String",
      Input(string: "strIng"): "str_Ing",
      Input(string: "strING"): "str_ING",
      Input(string: "X"): "X",
      Input(string: "x"): "x",
      Input(string: "SomeCapString"): "Some_Cap_String",
      Input(string: "someCapString"): "some_Cap_String",
      Input(string: "string_with_words"): "string_with_words",
      Input(string: "String_with_words"): "String_with_words",
      Input(string: "String_With_Words"): "String_With_Words",
      Input(string: "String_With_WoRds"): "String_With_Wo_Rds",
      Input(string: "STRing_with_words"): "ST_Ring_with_words",
      Input(string: "string_wiTH_WOrds"): "string_wi_TH_W_Ords",
      Input(string: ""): "",
      Input(string: "URLChooser"): "URL_Chooser",
      Input(string: "UrlChooser"): "Url_Chooser",
      Input(string: "a__b__c"): "a__b__c",
      Input(string: "__y_z!"): "__y_z!",
      Input(string: "PLEASESTOPSCREAMING"): "PLEASESTOPSCREAMING",
      Input(string: "PLEASESTOPSCREAMING!"): "PLEASESTOPSCREAMING!",
      Input(string: "PLEASE_STOP_SCREAMING"): "PLEASE_STOP_SCREAMING",
      Input(string: "PLEASE_STOP_SCREAMING!"): "PLEASE_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let falseArgResult = try Filters.Strings.camelToSnakeCase(input, arguments: ["false"]) as? String
      XCTAssertEqual(falseArgResult, expected)
    }
  }
}

extension StringFiltersTests {
  func testEscapeReservedKeywords() throws {
    let expectations: [Input: String] = [
      Input(string: "self"): "`self`",
      Input(string: "foo"): "foo",
      Input(string: "Type"): "`Type`",
      Input(string: ""): "",
      Input(string: "x"): "x",
      Input(string: "Bar"): "Bar",
      Input(string: "#imageLiteral"): "`#imageLiteral`"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.escapeReservedKeywords(value: input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testLowerFirstWord() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "string",
      Input(string: "String"): "string",
      Input(string: "strIng"): "strIng",
      Input(string: "strING"): "strING",
      Input(string: "X"): "x",
      Input(string: "x"): "x",
      Input(string: "SomeCapString"): "someCapString",
      Input(string: "someCapString"): "someCapString",
      Input(string: "string_with_words"): "string_with_words",
      Input(string: "String_with_words"): "string_with_words",
      Input(string: "String_With_Words"): "string_With_Words",
      Input(string: "STRing_with_words"): "stRing_with_words",
      Input(string: "string_wiTH_WOrds"): "string_wiTH_WOrds",
      Input(string: ""): "",
      Input(string: "URLChooser"): "urlChooser",
      Input(string: "a__b__c"): "a__b__c",
      Input(string: "__y_z!"): "__y_z!",
      Input(string: "PLEASESTOPSCREAMING"): "pleasestopscreaming",
      Input(string: "PLEASESTOPSCREAMING!"): "pleasestopscreaming!",
      Input(string: "PLEASE_STOP_SCREAMING"): "please_STOP_SCREAMING",
      Input(string: "PLEASE_STOP_SCREAMING!"): "please_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.lowerFirstWord(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testRemoveNewlines_WithNoArgsDefaultsToAll() throws {
    let result = try Filters.Strings.removeNewlines(Input(string: "test\n \ntest "), arguments: []) as? String
    XCTAssertEqual(result, "testtest")
  }

  func testRemoveNewlines_WithWrongArgWillThrow() throws {
    do {
      _ = try Filters.Strings.removeNewlines(Input(string: ""), arguments: ["wrong"])
      XCTFail("Code did succeed while it was expected to fail for wrong option")
    } catch Filters.Error.invalidOption {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }

  func testRemoveNewlines_WithAll() throws {
    let expectations: [Input: String] = [
      Input(string: "test1"): "test1",
      Input(string: "  \n test2"): "test2",
      Input(string: "test3  \n "): "test3",
      Input(string: "test4, \ntest, \ntest"): "test4,test,test",
      Input(string: "\n test5\n \ntest test \n "): "test5testtest",
      Input(string: "test6\ntest"): "test6test",
      Input(string: "test7 test"): "test7test"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.removeNewlines(input, arguments: ["all"]) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testRemoveNewlines_WithLeading() throws {
    let expectations: [Input: String] = [
      Input(string: "test1"): "test1",
      Input(string: "  \n test2"): "test2",
      Input(string: "test3  \n "): "test3",
      Input(string: "test4, \ntest, \ntest"): "test4, test, test",
      Input(string: "\n test5\n \ntest test \n "): "test5test test",
      Input(string: "test6\ntest"): "test6test",
      Input(string: "test7 test"): "test7 test"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.removeNewlines(input, arguments: ["leading"]) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testSnakeToCamelCase_WithNoArgsDefaultsToFalse() throws {
    let result = try Filters.Strings.snakeToCamelCase(Input(string: "__y_z!"), arguments: []) as? String
    XCTAssertEqual(result, "__YZ!")
  }

  func testSnakeToCamelCase_WithFalse() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "String",
      Input(string: "String"): "String",
      Input(string: "strIng"): "StrIng",
      Input(string: "strING"): "StrING",
      Input(string: "X"): "X",
      Input(string: "x"): "X",
      Input(string: "SomeCapString"): "SomeCapString",
      Input(string: "someCapString"): "SomeCapString",
      Input(string: "string_with_words"): "StringWithWords",
      Input(string: "String_with_words"): "StringWithWords",
      Input(string: "String_With_Words"): "StringWithWords",
      Input(string: "STRing_with_words"): "STRingWithWords",
      Input(string: "string_wiTH_WOrds"): "StringWiTHWOrds",
      Input(string: ""): "",
      Input(string: "URLChooser"): "URLChooser",
      Input(string: "a__b__c"): "ABC",
      Input(string: "__y_z!"): "__YZ!",
      Input(string: "PLEASESTOPSCREAMING"): "Pleasestopscreaming",
      Input(string: "PLEASESTOPSCREAMING!"): "Pleasestopscreaming!",
      Input(string: "PLEASE_STOP_SCREAMING"): "PleaseStopScreaming",
      Input(string: "PLEASE_STOP_SCREAMING!"): "PleaseStopScreaming!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.snakeToCamelCase(input, arguments: ["false"]) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testSnakeToCamelCase_WithTrue() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "String",
      Input(string: "String"): "String",
      Input(string: "strIng"): "StrIng",
      Input(string: "strING"): "StrING",
      Input(string: "X"): "X",
      Input(string: "x"): "X",
      Input(string: "SomeCapString"): "SomeCapString",
      Input(string: "someCapString"): "SomeCapString",
      Input(string: "string_with_words"): "StringWithWords",
      Input(string: "String_with_words"): "StringWithWords",
      Input(string: "String_With_Words"): "StringWithWords",
      Input(string: "STRing_with_words"): "STRingWithWords",
      Input(string: "string_wiTH_WOrds"): "StringWiTHWOrds",
      Input(string: ""): "",
      Input(string: "URLChooser"): "URLChooser",
      Input(string: "a__b__c"): "ABC",
      Input(string: "__y_z!"): "YZ!",
      Input(string: "PLEASESTOPSCREAMING"): "Pleasestopscreaming",
      Input(string: "PLEASESTOPSCREAMING!"): "Pleasestopscreaming!",
      Input(string: "PLEASE_STOP_SCREAMING"): "PleaseStopScreaming",
      Input(string: "PLEASE_STOP_SCREAMING!"): "PleaseStopScreaming!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.snakeToCamelCase(input, arguments: ["true"]) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testUpperFirstLetter() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "String",
      Input(string: "String"): "String",
      Input(string: "strIng"): "StrIng",
      Input(string: "strING"): "StrING",
      Input(string: "X"): "X",
      Input(string: "x"): "X",
      Input(string: "SomeCapString"): "SomeCapString",
      Input(string: "someCapString"): "SomeCapString",
      Input(string: "string_with_words"): "String_with_words",
      Input(string: "String_with_words"): "String_with_words",
      Input(string: "String_With_Words"): "String_With_Words",
      Input(string: "STRing_with_words"): "STRing_with_words",
      Input(string: "string_wiTH_WOrds"): "String_wiTH_WOrds",
      Input(string: ""): "",
      Input(string: "URLChooser"): "URLChooser",
      Input(string: "a__b__c"): "A__b__c",
      Input(string: "__y_z!"): "__y_z!",
      Input(string: "PLEASESTOPSCREAMING"): "PLEASESTOPSCREAMING",
      Input(string: "PLEASESTOPSCREAMING!"): "PLEASESTOPSCREAMING!",
      Input(string: "PLEASE_STOP_SCREAMING"): "PLEASE_STOP_SCREAMING",
      Input(string: "PLEASE_STOP_SCREAMING!"): "PLEASE_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.upperFirstLetter(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testLowerFirstLetter() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "string",
      Input(string: "String"): "string",
      Input(string: "strIng"): "strIng",
      Input(string: "strING"): "strING",
      Input(string: "X"): "x",
      Input(string: "x"): "x",
      Input(string: "SomeCapString"): "someCapString",
      Input(string: "someCapString"): "someCapString",
      Input(string: "string with words"): "string with words",
      Input(string: "String with words"): "string with words",
      Input(string: "String With Words"): "string With Words",
      Input(string: "STRing with words"): "sTRing with words",
      Input(string: "string wiTH WOrds"): "string wiTH WOrds",
      Input(string: ""): "",
      Input(string: "A__B__C"): "a__B__C",
      Input(string: "__y_z!"): "__y_z!",
      Input(string: "PLEASESTOPSCREAMING"): "pLEASESTOPSCREAMING",
      Input(string: "PLEASESTOPSCREAMING!"): "pLEASESTOPSCREAMING!",
      Input(string: "PLEASE_STOP_SCREAMING"): "pLEASE_STOP_SCREAMING",
      Input(string: "PLEASE STOP SCREAMING!"): "pLEASE STOP SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.lowerFirstLetter(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testContains_WithTrueResult() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "s",
      Input(string: "String"): "ing",
      Input(string: "strIng"): "strIng",
      Input(string: "strING"): "rING",
      Input(string: "x"): "x",
      Input(string: "X"): "X",
      Input(string: "SomeCapString"): "Some",
      Input(string: "someCapString"): "apSt",
      Input(string: "string with words"): "with",
      Input(string: "String with words"): "th words",
      Input(string: "A__B__C"): "_",
      Input(string: "__y_z!"): "!"
    ]

    for (input, substring) in expectations {
      let result = try Filters.Strings.contains(input, arguments: [substring])
      XCTAssertTrue(result)
    }
  }

  func testContains_WithFalseResult() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "a",
      Input(string: "String"): "blabla",
      Input(string: "strIng"): "foo",
      Input(string: "strING"): "ing",
      Input(string: "X"): "x",
      Input(string: "string with words"): "string with sentences",
      Input(string: ""): "y",
      Input(string: "A__B__C"): "a__B__C",
      Input(string: "__y_z!"): "___"
    ]

    for (input, substring) in expectations {
      let result = try Filters.Strings.contains(input, arguments: [substring])
      XCTAssertFalse(result)
    }
  }
}

extension StringFiltersTests {
  func testHasPrefix_WithTrueResult() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "s",
      Input(string: "String"): "Str",
      Input(string: "strIng"): "strIng",
      Input(string: "strING"): "strI",
      Input(string: "x"): "x",
      Input(string: "X"): "X",
      Input(string: "SomeCapString"): "Some",
      Input(string: "someCapString"): "someCap",
      Input(string: "string with words"): "string",
      Input(string: "String with words"): "String with",
      Input(string: "A__B__C"): "A",
      Input(string: "__y_z!"): "__",
      Input(string: "AnotherString"): ""
    ]

    for (input, prefix) in expectations {
      let result = try Filters.Strings.hasPrefix(input, arguments: [prefix])
      XCTAssertTrue(result)
    }
  }

  func testHasPrefix_WithFalseResult() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "tring",
      Input(string: "String"): "str",
      Input(string: "strING"): "striNG",
      Input(string: "X"): "x",
      Input(string: "string with words"): "words with words",
      Input(string: ""): "y",
      Input(string: "A__B__C"): "a__B__C",
      Input(string: "__y_z!"): "!"
    ]

    for (input, prefix) in expectations {
      let result = try Filters.Strings.hasPrefix(input, arguments: [prefix])
      XCTAssertFalse(result)
    }
  }
}

extension StringFiltersTests {
  func testHasSuffix_WithTrueResult() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "g",
      Input(string: "String"): "ring",
      Input(string: "strIng"): "trIng",
      Input(string: "strING"): "strING",
      Input(string: "X"): "X",
      Input(string: "x"): "x",
      Input(string: "SomeCapString"): "CapString",
      Input(string: "string with words"): "with words",
      Input(string: "String with words"): " words",
      Input(string: "string wiTH WOrds"): "",
      Input(string: "A__B__C"): "_C",
      Input(string: "__y_z!"): "z!"
    ]

    for (input, suffix) in expectations {
      let result = try Filters.Strings.hasSuffix(input, arguments: [suffix])
      XCTAssertTrue(result)
    }
  }

  func testHasSuffix_WithFalseResult() throws {
    let expectations: [Input: String] = [
      Input(string: "string"): "gni",
      Input(string: "String"): "Ing",
      Input(string: "strIng"): "ing",
      Input(string: "strING"): "nG",
      Input(string: "X"): "x",
      Input(string: "x"): "X",
      Input(string: "string with words"): "with  words",
      Input(string: "String with words"): " Words",
      Input(string: "String With Words"): "th_Words",
      Input(string: ""): "aa",
      Input(string: "A__B__C"): "C__B",
      Input(string: "__y_z!"): "z?"
    ]

    for (input, suffix) in expectations {
      let result = try Filters.Strings.hasSuffix(input, arguments: [suffix])
      XCTAssertFalse(result)
    }
  }
}

extension StringFiltersTests {
  func testReplace() throws {
    let expectations = [
      (Input(string: "string"), "ing", "oke", "stroke"),
      (Input(string: "string"), "folks", "mates", "string"),
      (Input(string: "hi mates!"), "hi", "Yo", "Yo mates!"),
      (Input(string: "string with spaces"), " ", "_", "string_with_spaces")
    ]

    for (input, substring, replacement, expected) in expectations {
      let result = try Filters.Strings.replace(input, arguments: [substring, replacement]) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testReplaceRegex() throws {
    let expectations = [
      (Input(string: "string"), "ing", "oke", "stroke"),
      (Input(string: "string with numbers 42"), "\\s\\d+$", "", "string with numbers")
    ]

    for (input, substring, replacement, expected) in expectations {
      let result = try Filters.Strings.replace(input, arguments: [substring, replacement, "regex"]) as? String
        XCTAssertEqual(result, expected)
      }
  }
}

extension StringFiltersTests {
  func testBasename() throws {
    let expectations: [Input: String] = [
      Input(string: "/tmp/scratch.tiff"): "scratch.tiff",
      Input(string: "/tmp/scratch"): "scratch",
      Input(string: "/tmp/"): "tmp",
      Input(string: "scratch///"): "scratch",
      Input(string: "/"): "/"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.basename(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testDirname() throws {
    let expectations: [Input: String] = [
      Input(string: "/tmp/scratch.tiff"): "/tmp",
      Input(string: "/tmp/lock/"): "/tmp",
      Input(string: "/tmp/"): "/",
      Input(string: "/tmp"): "/",
      Input(string: "/"): "/",
      Input(string: "scratch.tiff"): "."
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.dirname(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
