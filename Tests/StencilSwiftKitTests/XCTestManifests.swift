import XCTest

extension CallNodeTests {
    static let __allTests = [
        ("testParser", testParser),
        ("testParserFail", testParserFail),
        ("testParserWithArgumentsRange", testParserWithArgumentsRange),
        ("testParserWithArgumentsVariable", testParserWithArgumentsVariable),
        ("testRender", testRender),
        ("testRenderFail", testRenderFail),
        ("testRenderWithParameters", testRenderWithParameters),
        ("testRenderWithParametersFail", testRenderWithParametersFail),
    ]
}

extension ContextTests {
    static let __allTests = [
        ("testEmpty", testEmpty),
        ("testWithContext", testWithContext),
        ("testWithParameters", testWithParameters),
    ]
}

extension MacroNodeTests {
    static let __allTests = [
        ("testCallableBlockContext", testCallableBlockContext),
        ("testCallableBlockWithFilterExpressionParameter", testCallableBlockWithFilterExpressionParameter),
        ("testContextModification", testContextModification),
        ("testContextModificationWithParameters", testContextModificationWithParameters),
        ("testParser", testParser),
        ("testParserFail", testParserFail),
        ("testParserWithParameters", testParserWithParameters),
        ("testRender", testRender),
        ("testRenderWithParameters", testRenderWithParameters),
    ]
}

extension MapNodeTests {
    static let __allTests = [
        ("testContext", testContext),
        ("testMapLoopContext", testMapLoopContext),
        ("testParserFail", testParserFail),
        ("testParserFilterExpression", testParserFilterExpression),
        ("testParserRange", testParserRange),
        ("testParserWithMapVariable", testParserWithMapVariable),
        ("testRender", testRender),
    ]
}

extension ParametersTests {
    static let __allTests = [
        ("testBasic", testBasic),
        ("testDeepStructured", testDeepStructured),
        ("testParseInvalidKey", testParseInvalidKey),
        ("testParseInvalidStructure", testParseInvalidStructure),
        ("testParseInvalidSyntax", testParseInvalidSyntax),
        ("testRepeated", testRepeated),
        ("testStructured", testStructured),
    ]
}

extension ParseBoolTests {
    static let __allTests = [
        ("testParseBool_FalseWithString", testParseBool_FalseWithString),
        ("testParseBool_TrueWithString", testParseBool_TrueWithString),
        ("testParseBool_WithEmptyArrayAndRequiredArg", testParseBool_WithEmptyArrayAndRequiredArg),
        ("testParseBool_WithEmptyArray", testParseBool_WithEmptyArray),
        ("testParseBool_WithEmptyStringAndRequiredArg", testParseBool_WithEmptyStringAndRequiredArg),
        ("testParseBool_WithEmptyString", testParseBool_WithEmptyString),
        ("testParseBool_WithNonZeroIndex", testParseBool_WithNonZeroIndex),
        ("testParseBool_WithOptionalDouble", testParseBool_WithOptionalDouble),
        ("testParseBool_WithOptionalInt", testParseBool_WithOptionalInt),
        ("testParseBool_WithRequiredDouble", testParseBool_WithRequiredDouble),
        ("testParseBool_WithRequiredInt", testParseBool_WithRequiredInt),
    ]
}

extension ParseEnumTests {
    static let __allTests = [
        ("testParseEnum_WithBarString", testParseEnum_WithBarString),
        ("testParseEnum_WithBazString", testParseEnum_WithBazString),
        ("testParseEnum_WithEmptyArray", testParseEnum_WithEmptyArray),
        ("testParseEnum_WithFooString", testParseEnum_WithFooString),
        ("testParseEnum_WithNonZeroIndex", testParseEnum_WithNonZeroIndex),
        ("testParseEnum_WithUnknownArgument", testParseEnum_WithUnknownArgument),
    ]
}

extension ParseStringTests {
    static let __allTests = [
        ("testParseString_FromValue_WithNil", testParseString_FromValue_WithNil),
        ("testParseString_FromValue_WithNonStringConvertableArgument", testParseString_FromValue_WithNonStringConvertableArgument),
        ("testParseString_FromValue_WithNSStringValue", testParseString_FromValue_WithNSStringValue),
        ("testParseString_FromValue_WithStringConvertableArgument", testParseString_FromValue_WithStringConvertableArgument),
        ("testParseString_FromValue_WithStringLosslessConvertableArgument", testParseString_FromValue_WithStringLosslessConvertableArgument),
        ("testParseString_FromValue_WithStringValue", testParseString_FromValue_WithStringValue),
        ("testParseStringArgument_WithEmptyArray", testParseStringArgument_WithEmptyArray),
        ("testParseStringArgument_WithNonStringConvertableArgument", testParseStringArgument_WithNonStringConvertableArgument),
        ("testParseStringArgument_WithNonZeroIndex", testParseStringArgument_WithNonZeroIndex),
        ("testParseStringArgument_WithStringArgument", testParseStringArgument_WithStringArgument),
        ("testParseStringArgument_WithStringConvertableArgument", testParseStringArgument_WithStringConvertableArgument),
        ("testParseStringArgument_WithStringLosslessConvertableArgument", testParseStringArgument_WithStringLosslessConvertableArgument),
    ]
}

extension SetNodeTests {
    static let __allTests = [
        ("testContextModification", testContextModification),
        ("testContextPush", testContextPush),
        ("testDifferenceRenderEvaluate", testDifferenceRenderEvaluate),
        ("testParserEvaluateModeRange", testParserEvaluateModeRange),
        ("testParserEvaluateModeVariable", testParserEvaluateModeVariable),
        ("testParserFail", testParserFail),
        ("testParserRenderMode", testParserRenderMode),
        ("testRender", testRender),
        ("testSetWithFilterExpressionParameter", testSetWithFilterExpressionParameter),
        ("testWithExistingContext", testWithExistingContext),
    ]
}

extension StringFiltersTests {
    static let __allTests = [
        ("testBasename", testBasename),
        ("testCamelToSnakeCase_WithFalse", testCamelToSnakeCase_WithFalse),
        ("testCamelToSnakeCase_WithNoArgsDefaultsToTrue", testCamelToSnakeCase_WithNoArgsDefaultsToTrue),
        ("testCamelToSnakeCase_WithTrue", testCamelToSnakeCase_WithTrue),
        ("testContains_WithFalseResult", testContains_WithFalseResult),
        ("testContains_WithTrueResult", testContains_WithTrueResult),
        ("testDirname", testDirname),
        ("testEscapeReservedKeywords", testEscapeReservedKeywords),
        ("testHasPrefix_WithFalseResult", testHasPrefix_WithFalseResult),
        ("testHasPrefix_WithTrueResult", testHasPrefix_WithTrueResult),
        ("testHasSuffix_WithFalseResult", testHasSuffix_WithFalseResult),
        ("testHasSuffix_WithTrueResult", testHasSuffix_WithTrueResult),
        ("testLowerFirstLetter", testLowerFirstLetter),
        ("testLowerFirstWord", testLowerFirstWord),
        ("testRemoveNewlines_WithAll", testRemoveNewlines_WithAll),
        ("testRemoveNewlines_WithLeading", testRemoveNewlines_WithLeading),
        ("testRemoveNewlines_WithNoArgsDefaultsToAll", testRemoveNewlines_WithNoArgsDefaultsToAll),
        ("testRemoveNewlines_WithWrongArgWillThrow", testRemoveNewlines_WithWrongArgWillThrow),
        ("testReplace", testReplace),
        ("testSnakeToCamelCase_WithFalse", testSnakeToCamelCase_WithFalse),
        ("testSnakeToCamelCase_WithNoArgsDefaultsToFalse", testSnakeToCamelCase_WithNoArgsDefaultsToFalse),
        ("testSnakeToCamelCase_WithTrue", testSnakeToCamelCase_WithTrue),
        ("testUpperFirstLetter", testUpperFirstLetter),
    ]
}

extension SwiftIdentifierTests {
    static let __allTests = [
        ("testBasicString", testBasicString),
        ("testBasicStringWithForbiddenChars", testBasicStringWithForbiddenChars),
        ("testBasicStringWithForbiddenCharsAndUnderscores", testBasicStringWithForbiddenCharsAndUnderscores),
        ("testEmojis", testEmojis),
        ("testEmojis2", testEmojis2),
        ("testForbiddenChars", testForbiddenChars),
        ("testKeepUppercaseAcronyms", testKeepUppercaseAcronyms),
        ("testNumbersFirst", testNumbersFirst),
        ("testSpecialChars", testSpecialChars),
        ("testSwiftIdentifier_WithNoArgsDefaultsToNormal", testSwiftIdentifier_WithNoArgsDefaultsToNormal),
        ("testSwiftIdentifier_WithNormal", testSwiftIdentifier_WithNormal),
        ("testSwiftIdentifier_WithPretty", testSwiftIdentifier_WithPretty),
        ("testSwiftIdentifier_WithWrongArgWillThrow", testSwiftIdentifier_WithWrongArgWillThrow),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CallNodeTests.__allTests),
        testCase(ContextTests.__allTests),
        testCase(MacroNodeTests.__allTests),
        testCase(MapNodeTests.__allTests),
        testCase(ParametersTests.__allTests),
        testCase(ParseBoolTests.__allTests),
        testCase(ParseEnumTests.__allTests),
        testCase(ParseStringTests.__allTests),
        testCase(SetNodeTests.__allTests),
        testCase(StringFiltersTests.__allTests),
        testCase(SwiftIdentifierTests.__allTests),
    ]
}
#endif
