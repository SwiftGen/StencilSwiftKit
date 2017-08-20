//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

extension Filters {
  enum Strings {
    /// Checks if the given string contains given substring
    ///
    /// - Parameters:
    ///   - value: the string value to check if it contains substring
    ///   - arguments: the arguments to the function; expecting one string argument - substring
    /// - Returns: the result whether true or not
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or 
    ///           if number of arguments is not one or if the given argument isn't a string
    static func contains(_ value: Any?, arguments: [Any?]) throws -> Bool {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      guard let substring = arguments.first as? String else { throw Filters.Error.invalidInputType }
      return string.contains(substring)
    }

    /// Checks if the given string has given prefix
    ///
    /// - Parameters:
    ///   - value: the string value to check if it has prefix
    ///   - arguments: the arguments to the function; expecting one string argument - prefix
    /// - Returns: the result whether true or not
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
    ///           if number of arguments is not one or if the given argument isn't a string
    static func hasPrefix(_ value: Any?, arguments: [Any?]) throws -> Bool {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      guard let prefix = arguments.first as? String else { throw Filters.Error.invalidInputType }
      return string.hasPrefix(prefix)
    }

    /// Checks if the given string has given suffix
    ///
    /// - Parameters:
    ///   - value: the string value to check if it has prefix
    ///   - arguments: the arguments to the function; expecting one string argument - suffix
    /// - Returns: the result whether true or not
    /// - Throws: FilterError.invalidInputType if the value parameter isn't a string or
    ///           if number of arguments is not one or if the given argument isn't a string
    static func hasSuffix(_ value: Any?, arguments: [Any?]) throws -> Bool {
      guard let string = value as? String else { throw Filters.Error.invalidInputType }
      guard let suffix = arguments.first as? String else { throw Filters.Error.invalidInputType }
      return string.hasSuffix(suffix)
    }
  }
}
