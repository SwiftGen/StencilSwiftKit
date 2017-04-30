//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

enum FilterError: Error {
  case invalidInputType
}

enum Filters {
  /// Parses filter arguments for a boolean value, where true can by any one of: "true", "yes", "1", and
  /// false can be any one of: "false", "no", "0". If optional is true it means that the argument on the filter is
  /// optional and it's not an error condition if the argument is missing or not the right type
  /// - parameter arguments: an array of argument values, may be empty
  /// - parameter index: the index in the arguments array
  /// - parameter required: If true, the argument is required and function throws if missing.
  ///                       If false, returns nil on missing args.
  /// - returns: true or false if a value was parsed, or nil if it wasn't able to
  static func parseBool(from arguments: [Any?], index: Int, required: Bool = true) throws -> Bool? {
    guard index < arguments.count, let boolArg = arguments[index] as? String else {
      if required {
        throw FilterError.invalidInputType
      } else {
        return nil
      }
    }

    switch boolArg.lowercased() {
    case "false", "no", "0":
      return false
    case "true", "yes", "1":
      return true
    default:
      throw FilterError.invalidInputType
    }
  }
}

struct ArrayFilters {
  static func join(_ value: Any?) throws -> Any? {
    guard let array = value as? [Any] else { throw FilterError.invalidInputType }
    let strings = array.flatMap { $0 as? String }
    guard array.count == strings.count else { throw FilterError.invalidInputType }

    return strings.joined(separator: ", ")
  }
}
