//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil

public extension Extension {
  public func registerStencilSwiftExtensions() {
    registerTag("set", parser: SetNode.parse)
    registerTag("macro", parser: MacroNode.parse)
    registerTag("call", parser: CallNode.parse)
    registerTag("map", parser: MapNode.parse)

    registerFilter("camelToSnakeCase", filter: Filters.Strings.camelToSnakeCase)
    registerFilter("escapeReservedKeywords", filter: Filters.Strings.escapeReservedKeywords)
    registerFilter("lowerFirstWord", filter: Filters.Strings.lowerFirstWord)
    registerFilter("removeNewlines", filter: Filters.Strings.removeNewlines)
    registerFilter("snakeToCamelCase", filter: Filters.Strings.snakeToCamelCase)
    registerFilter("swiftIdentifier", filter: Filters.Strings.swiftIdentifier)
    registerFilter("titlecase", filter: Filters.Strings.titlecase)
    registerFilter("lowerFirstLetter", filter: Filters.Strings.lowerFirstLetter)
    registerBoolFilterWithArguments("contains", filter: Filters.Strings.contains)
    registerBoolFilterWithArguments("hasPrefix", filter: Filters.Strings.hasPrefix)
    registerBoolFilterWithArguments("hasSuffix", filter: Filters.Strings.hasSuffix)
    registerFilterWithTwoArguments("replace", filter: Filters.Strings.replace)

    registerFilter("hexToInt", filter: Filters.Numbers.hexToInt)
    registerFilter("int255toFloat", filter: Filters.Numbers.int255toFloat)
    registerFilter("percent", filter: Filters.Numbers.percent)
  }
}

public func stencilSwiftEnvironment() -> Environment {
  let ext = Extension()
  ext.registerStencilSwiftExtensions()

  return Environment(extensions: [ext], templateClass: StencilSwiftTemplate.self)
}

extension Stencil.Extension {
  // The following swiftlint annotation needs to be deleted once a swiftlint version including this PR
  // https://github.com/realm/SwiftLint/pull/1725 is released.
  // swiftlint:disable:next large_tuple
  func registerFilterWithTwoArguments<T, A, B>(_ name: String, filter: @escaping (T, A, B) throws -> Any?) {
    registerFilter(name) { (any, args) throws -> Any? in
      guard let type = any as? T else { return any }
      guard args.count == 2, let argA = args[0] as? A, let argB = args[1] as? B else {
        throw TemplateSyntaxError("'\(name)' filter takes two arguments: \(A.self) and \(B.self)")
      }
      return try filter(type, argA, argB)
    }
  }

  func registerFilterWithArguments<A>(_ name: String, filter: @escaping (Any?, A) throws -> Any?) {
    registerFilter(name) { (any, args) throws -> Any? in
      guard args.count == 1, let arg = args.first as? A else {
        throw TemplateSyntaxError("'\(name)' filter takes a single \(A.self) argument")
      }
      return try filter(any, arg)
    }
  }

  func registerBoolFilterWithArguments<U, A>(_ name: String, filter: @escaping (U, A) -> Bool) {
    registerFilterWithArguments(name, filter: Filter.make(filter))
    registerFilterWithArguments("!\(name)", filter: Filter.make({ !filter($0, $1) }))
  }
}

private struct Filter<T> {
  static func make(_ filter: @escaping (T) -> Bool) -> (Any?) throws -> Any? {
    return { (any) throws -> Any? in
      switch any {
      case let type as T:
        return filter(type)

      case let array as [Any]:
        return array.flatMap { $0 as? T }.filter(filter)

      default:
        return any
      }
    }
  }

  static func make<U>(_ filter: @escaping (T) -> U?) -> (Any?) throws -> Any? {
    return { (any) throws -> Any? in
      switch any {
      case let type as T:
        return filter(type)

      case let array as [Any]:
        return array.flatMap { $0 as? T }.flatMap(filter)

      default:
        return any
      }
    }
  }

  static func make<A>(_ filter: @escaping (T, A) -> Bool) -> (Any?, A) throws -> Any? {
    return { (any, arg) throws -> Any? in
      switch any {
      case let type as T:
        return filter(type, arg)

      case let array as [Any]:
        return array.flatMap { $0 as? T }.filter({ filter($0, arg) })

      default:
        return any
      }
    }
  }
}
