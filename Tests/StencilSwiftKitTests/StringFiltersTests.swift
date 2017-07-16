//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import XCTest
@testable import StencilSwiftKit

final class StringFiltersTests: XCTestCase {
  func testCamelToSnakeCase_WithNoArgsDefaultsToTrue() throws {
    let result = try Filters.Strings.camelToSnakeCase("StringWithWords", arguments: []) as? String
    XCTAssertEqual(result, "string_with_words")
  }
  
  func testCamelToSnakeCase_WithTrue() throws {
    let expectations = [
      "string": "string",
      "String": "string",
      "strIng": "str_ing",
      "strING": "str_ing",
      "X": "x",
      "x": "x",
      "SomeCapString": "some_cap_string",
      "someCapString": "some_cap_string",
      "string_with_words": "string_with_words",
      "String_with_words": "string_with_words",
      "String_With_Words": "string_with_words",
      "String_With_WoRds": "string_with_wo_rds",
      "STRing_with_words": "st_ring_with_words",
      "string_wiTH_WOrds": "string_wi_th_w_ords",
      "": "",
      "URLChooser": "url_chooser",
      "UrlChooser": "url_chooser",
      "a__b__c": "a__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "please_stop_screaming",
      "PLEASE_STOP_SCREAMING!": "please_stop_screaming!"
    ]

    for (input, expected) in expectations {
      let trueArgResult = try Filters.Strings.camelToSnakeCase(input, arguments: ["true"]) as? String
      XCTAssertEqual(trueArgResult, expected)
    }
  }

  func testCamelToSnakeCase_WithFalse() throws {
    let expectations = [
      "string": "string",
      "String": "String",
      "strIng": "str_Ing",
      "strING": "str_ING",
      "X": "X",
      "x": "x",
      "SomeCapString": "Some_Cap_String",
      "someCapString": "some_Cap_String",
      "string_with_words": "string_with_words",
      "String_with_words": "String_with_words",
      "String_With_Words": "String_With_Words",
      "String_With_WoRds": "String_With_Wo_Rds",
      "STRing_with_words": "ST_Ring_with_words",
      "string_wiTH_WOrds": "string_wi_TH_W_Ords",
      "": "",
      "URLChooser": "URL_Chooser",
      "UrlChooser": "Url_Chooser",
      "a__b__c": "a__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "PLEASESTOPSCREAMING",
      "PLEASESTOPSCREAMING!": "PLEASESTOPSCREAMING!",
      "PLEASE_STOP_SCREAMING": "PLEASE_STOP_SCREAMING",
      "PLEASE_STOP_SCREAMING!": "PLEASE_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let falseArgResult = try Filters.Strings.camelToSnakeCase(input, arguments: ["false"]) as? String
      XCTAssertEqual(falseArgResult, expected)
    }
  }
}

extension StringFiltersTests {
  func testEscapeReservedKeywords() throws {
    let expectations = [
      "self": "`self`",
      "foo": "foo",
      "Type": "`Type`",
      "": "",
      "x": "x",
      "Bar": "Bar",
      "#imageLiteral": "`#imageLiteral`"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.escapeReservedKeywords(value: input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testLowerFirstWord() throws {
    let expectations = [
      "string": "string",
      "String": "string",
      "strIng": "strIng",
      "strING": "strING",
      "X": "x",
      "x": "x",
      "SomeCapString": "someCapString",
      "someCapString": "someCapString",
      "string_with_words": "string_with_words",
      "String_with_words": "string_with_words",
      "String_With_Words": "string_With_Words",
      "STRing_with_words": "stRing_with_words",
      "string_wiTH_WOrds": "string_wiTH_WOrds",
      "": "",
      "URLChooser": "urlChooser",
      "a__b__c": "a__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "please_STOP_SCREAMING",
      "PLEASE_STOP_SCREAMING!": "please_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.lowerFirstWord(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testRemoveNewlines_WithNoArgsDefaultsToAll() throws {
    let result = try Filters.Strings.removeNewlines("test\n \ntest ", arguments: []) as? String
    XCTAssertEqual(result, "testtest")
  }

  func testRemoveNewlines_WithWrongArgWillThrow() throws {
    do {
      _ = try Filters.Strings.removeNewlines("", arguments: ["wrong"])
      XCTFail("Code did succeed while it was expected to fail for wrong option")
    } catch Filters.Error.invalidOption {
      // That's the expected exception we want to happen
    } catch let error {
      XCTFail("Unexpected error occured: \(error)")
    }
  }

  func testRemoveNewlines_WithAll() throws {
    let expectations = [
      "test1": "test1",
      "  \n test2": "test2",
      "test3  \n ": "test3",
      "test4, \ntest, \ntest": "test4,test,test",
      "\n test5\n \ntest test \n ": "test5testtest",
      "test6\ntest": "test6test",
      "test7 test": "test7test"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.removeNewlines(input, arguments: ["all"]) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testRemoveNewlines_WithLeading() throws {
    let expectations = [
      "test1": "test1",
      "  \n test2": "test2",
      "test3  \n ": "test3",
      "test4, \ntest, \ntest": "test4, test, test",
      "\n test5\n \ntest test \n ": "test5test test",
      "test6\ntest": "test6test",
      "test7 test": "test7 test"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.removeNewlines(input, arguments: ["leading"]) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testSnakeToCamelCase_WithNoArgsDefaultsToFalse() throws {
    let result = try Filters.Strings.snakeToCamelCase("__y_z!", arguments: []) as? String
    XCTAssertEqual(result, "__YZ!")
  }

  func testSnakeToCamelCase_WithFalse() throws {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string_with_words": "StringWithWords",
      "String_with_words": "StringWithWords",
      "String_With_Words": "StringWithWords",
      "STRing_with_words": "STRingWithWords",
      "string_wiTH_WOrds": "StringWiTHWOrds",
      "": "",
      "URLChooser": "URLChooser",
      "a__b__c": "ABC",
      "__y_z!": "__YZ!",
      "PLEASESTOPSCREAMING": "Pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "Pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "PleaseStopScreaming",
      "PLEASE_STOP_SCREAMING!": "PleaseStopScreaming!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.snakeToCamelCase(input, arguments: ["false"]) as? String
      XCTAssertEqual(result, expected)
    }
  }

  func testSnakeToCamelCase_WithTrue() throws {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string_with_words": "StringWithWords",
      "String_with_words": "StringWithWords",
      "String_With_Words": "StringWithWords",
      "STRing_with_words": "STRingWithWords",
      "string_wiTH_WOrds": "StringWiTHWOrds",
      "": "",
      "URLChooser": "URLChooser",
      "a__b__c": "ABC",
      "__y_z!": "YZ!",
      "PLEASESTOPSCREAMING": "Pleasestopscreaming",
      "PLEASESTOPSCREAMING!": "Pleasestopscreaming!",
      "PLEASE_STOP_SCREAMING": "PleaseStopScreaming",
      "PLEASE_STOP_SCREAMING!": "PleaseStopScreaming!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.snakeToCamelCase(input, arguments: ["true"]) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testTitlecase() throws {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string_with_words": "String_with_words",
      "String_with_words": "String_with_words",
      "String_With_Words": "String_With_Words",
      "STRing_with_words": "STRing_with_words",
      "string_wiTH_WOrds": "String_wiTH_WOrds",
      "": "",
      "URLChooser": "URLChooser",
      "a__b__c": "A__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "PLEASESTOPSCREAMING",
      "PLEASESTOPSCREAMING!": "PLEASESTOPSCREAMING!",
      "PLEASE_STOP_SCREAMING": "PLEASE_STOP_SCREAMING",
      "PLEASE_STOP_SCREAMING!": "PLEASE_STOP_SCREAMING!"
    ]

    for (input, expected) in expectations {
      let result = try Filters.Strings.titlecase(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testUpperFirstLetter() throws {
    let expectations = [
      "string": "String",
      "String": "String",
      "strIng": "StrIng",
      "strING": "StrING",
      "X": "X",
      "x": "X",
      "SomeCapString": "SomeCapString",
      "someCapString": "SomeCapString",
      "string with words": "String with words",
      "String with words": "String with words",
      "String With Words": "String With Words",
      "STRing with words": "STRing with words",
      "string wiTH WOrds": "String wiTH WOrds",
      "": "",
      "a__b__c": "A__b__c",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "PLEASESTOPSCREAMING",
      "PLEASESTOPSCREAMING!": "PLEASESTOPSCREAMING!",
      "PLEASE_STOP_SCREAMING": "PLEASE_STOP_SCREAMING",
      "PLEASE STOP SCREAMING!": "PLEASE STOP SCREAMING!"
    ]
    
    for (input, expected) in expectations {
      let result = try Filters.Strings.upperFirstLetter(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testLowerFirstLetter() throws {
    let expectations = [
      "string": "string",
      "String": "string",
      "strIng": "strIng",
      "strING": "strING",
      "X": "x",
      "x": "x",
      "SomeCapString": "someCapString",
      "someCapString": "someCapString",
      "string with words": "string with words",
      "String with words": "string with words",
      "String With Words": "string With Words",
      "STRing with words": "sTRing with words",
      "string wiTH WOrds": "string wiTH WOrds",
      "": "",
      "A__B__C": "a__B__C",
      "__y_z!": "__y_z!",
      "PLEASESTOPSCREAMING": "pLEASESTOPSCREAMING",
      "PLEASESTOPSCREAMING!": "pLEASESTOPSCREAMING!",
      "PLEASE_STOP_SCREAMING": "pLEASE_STOP_SCREAMING",
      "PLEASE STOP SCREAMING!": "pLEASE STOP SCREAMING!"
    ]
    
    for (input, expected) in expectations {
      let result = try Filters.Strings.lowerFirstLetter(input) as? String
      XCTAssertEqual(result, expected)
    }
  }
}

extension StringFiltersTests {
  func testContains_WithTrueResult() throws {
    let expectations = [
      "string": "s",
      "String": "ing",
      "strIng": "strIng",
      "strING": "rING",
      "x": "x",
      "X": "X",
      "SomeCapString": "Some",
      "someCapString": "apSt",
      "string with words": "with",
      "String with words": "th words",
      "A__B__C": "_",
      "__y_z!": "!"
    ]
    
    for (input, substring) in expectations {
      let result = Filters.Strings.contains(input, substring: substring)
      XCTAssertTrue(result)
    }
  }
  
  func testContains_WithFalseResult() throws {
    let expectations = [
      "string": "a",
      "String": "blabla",
      "strIng": "foo",
      "strING": "ing",
      "X": "x",
      "string with words": "string with sentences",
      "": "y",
      "A__B__C": "a__B__C",
      "__y_z!": "___",
    ]
    
    for (input, substring) in expectations {
      let result = Filters.Strings.contains(input, substring: substring)
      XCTAssertFalse(result)
    }
  }
}

extension StringFiltersTests {
  func testHasPrefix_WithTrueResult() throws {
    let expectations = [
      "string": "s",
      "String": "Str",
      "strIng": "strIng",
      "strING": "strI",
      "x": "x",
      "X": "X",
      "SomeCapString": "Some",
      "someCapString": "someCap",
      "string with words": "string",
      "String with words": "String with",
      "A__B__C": "A",
      "__y_z!": "__",
      "AnotherString": ""
    ]
    
    for (input, prefix) in expectations {
      let result = Filters.Strings.hasPrefix(input, prefix: prefix)
      XCTAssertTrue(result)
    }
  }
  
  func testHasPrefix_WithFalseResult() throws {
    let expectations = [
      "string": "tring",
      "String": "str",
      "strING": "striNG",
      "X": "x",
      "string with words": "words with words",
      "": "y",
      "A__B__C": "a__B__C",
      "__y_z!": "!"
      ]
    
    for (input, prefix) in expectations {
      let result = Filters.Strings.hasPrefix(input, prefix: prefix)
      XCTAssertFalse(result)
    }
  }
}

extension StringFiltersTests {
  func testHasSuffix_WithTrueResult() throws {
    let expectations = [
      "string": "g",
      "String": "ring",
      "strIng": "trIng",
      "strING": "strING",
      "X": "X",
      "x": "x",
      "SomeCapString": "CapString",
      "string with words": "with words",
      "String with words": " words",
      "string wiTH WOrds": "",
      "A__B__C": "_C",
      "__y_z!": "z!"
    ]
    
    for (input, suffix) in expectations {
      let result = Filters.Strings.hasSuffix(input, suffix: suffix)
      XCTAssertTrue(result)
    }
  }
  
  func testHasSuffix_WithFalseResult() throws {
    let expectations = [
      "string": "gni",
      "String": "Ing",
      "strIng": "ing",
      "strING": "nG",
      "X": "x",
      "x": "X",
      "string with words": "with  words",
      "String with words": " Words",
      "String With Words": "th_Words",
      "": "aa",
      "A__B__C": "C__B",
      "__y_z!": "z?"
    ]
    
    for (input, suffix) in expectations {
      let result = Filters.Strings.hasSuffix(input, suffix: suffix)
      XCTAssertFalse(result)
    }
  }
}

extension StringFiltersTests {
  func testReplace() throws {
    let expectations = [
      ("string", "ing", "oke", "stroke"),
      ("string", "folks", "mates", "string"),
      ("hi mates!", "hi", "Yo", "Yo mates!"),
      ("string with spaces", " ", "_", "string_with_spaces"),
    ]
    
    for (input, substring, replacement, expected) in expectations {
      let result = try Filters.Strings.replace(source: input, substring: substring, replacement: replacement) as? String
      XCTAssertEqual(result, expected)
    }
  }
}
