//
// StencilSwiftKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import PathKit
import Stencil

public extension Extension {
  /// Registers this package's tags and filters
  func registerStencilSwiftExtensions() {
    registerTags()
    registerStringsFilters()
    registerNumbersFilters()
  }
}

private extension Extension {
  func registerFilter(_ name: String, filter: @escaping Filters.BooleanWithArguments) {
    typealias GenericFilter = (Any?, [Any?]) throws -> Any?
    let inverseFilter: GenericFilter = { value, arguments in
      try !filter(value, arguments)
    }
    registerFilter(name, filter: filter as GenericFilter)
    registerFilter("!\(name)", filter: inverseFilter)
  }

  func registerNumbersFilters() {
    registerFilter("hexToInt", filter: Filters.Numbers.hexToInt)
    registerFilter("int255toFloat", filter: Filters.Numbers.int255toFloat)
    registerFilter("percent", filter: Filters.Numbers.percent)
  }

  func registerStringsFilters() {
    registerFilter("basename", filter: Filters.Strings.basename)
    registerFilter("camelToSnakeCase", filter: Filters.Strings.camelToSnakeCase)
    registerFilter("dirname", filter: Filters.Strings.dirname)
    registerFilter("escapeReservedKeywords", filter: Filters.Strings.escapeReservedKeywords)
    registerFilter("lowerFirstLetter", filter: Filters.Strings.lowerFirstLetter)
    registerFilter("lowerFirstWord", filter: Filters.Strings.lowerFirstWord)
    registerFilter("removeNewlines", filter: Filters.Strings.removeNewlines)
    registerFilter("replace", filter: Filters.Strings.replace)
    registerFilter("snakeToCamelCase", filter: Filters.Strings.snakeToCamelCase)
    registerFilter("swiftIdentifier", filter: Filters.Strings.swiftIdentifier)
    registerFilter("titlecase", filter: Filters.Strings.upperFirstLetter)
    registerFilter("upperFirstLetter", filter: Filters.Strings.upperFirstLetter)
    registerFilter("contains", filter: Filters.Strings.contains)
    registerFilter("hasPrefix", filter: Filters.Strings.hasPrefix)
    registerFilter("hasSuffix", filter: Filters.Strings.hasSuffix)
  }

  func registerTags() {
    registerTag("set", parser: SetNode.parse)
    registerTag("macro", parser: MacroNode.parse)
    registerTag("call", parser: CallNode.parse)
    registerTag("map", parser: MapNode.parse)
    registerTag("import", parser: ImportNode.parse)
  }
}

/// Creates an Environment for Stencil to load & render templates
///
/// - Parameters:
///   - templatePaths: Paths where Stencil can search for templates, used for example for `include` tags
///   - extensions: Additional extensions with filters/tags/… you want to provide to Stencil
///   - templateClass: Custom template class to process templates
///   - trimBehaviour: Globally control how whitespace is handled, defaults to `smart`.
/// - Returns: A fully configured `Environment`
public func stencilSwiftEnvironment(
  templatePaths: [Path] = [],
  extensions: [Extension] = [],
  templateClass: Template.Type = Template.self,
  trimBehaviour: TrimBehaviour = .smart
) -> Environment {
  let ext = Extension()
  ext.registerStencilSwiftExtensions()

  return Environment(
    loader: FileSystemLoader(paths: templatePaths),
    extensions: extensions + [ext],
    templateClass: templateClass,
    trimBehaviour: trimBehaviour
  )
}

/// Creates an Environment for Stencil to load & render templates
///
/// - Parameters:
///   - templates: Templates that can be included, imported, etc…
///   - extensions: Additional extensions with filters/tags/… you want to provide to Stencil
///   - templateClass: Custom template class to process templates
///   - trimBehaviour: Globally control how whitespace is handled, defaults to `smart`.
/// - Returns: A fully configured `Environment`
public func stencilSwiftEnvironment(
  templates: [String: String],
  extensions: [Extension] = [],
  templateClass: Template.Type = Template.self,
  trimBehaviour: TrimBehaviour = .smart
) -> Environment {
  let ext = Extension()
  ext.registerStencilSwiftExtensions()

  return Environment(
    loader: DictionaryLoader(templates: templates),
    extensions: extensions + [ext],
    templateClass: templateClass,
    trimBehaviour: trimBehaviour
  )
}
