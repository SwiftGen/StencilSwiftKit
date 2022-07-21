//
// StencilSwiftKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

public extension Filters {
  /// Filters for operations related to numbers
  enum Numbers {
    /// Tries to parse the given `String` into an `Int` using radix 16.
    ///
    /// - Parameters:
    ///   - value: the string value to parse
    /// - Returns: the parsed `Int`
    /// - Throws: Filters.Error.invalidInputType if the value parameter isn't a string
    public static func hexToInt(_ value: Any?) throws -> Any? {
      guard let value = value as? String else { throw Filters.Error.invalidInputType }
      return Int(value, radix: 16)
    }

    /// Tries to convert the given `Int` to a `Float` by dividing it by 255.
    ///
    /// - Parameters:
    ///   - value: the `Int` value to convert
    /// - Returns: the convert `Float`
    /// - Throws: Filters.Error.invalidInputType if the value parameter isn't an integer
    public static func int255toFloat(_ value: Any?) throws -> Any? {
      guard let value = value as? Int else { throw Filters.Error.invalidInputType }
      return Float(value) / Float(255.0)
    }

    /// Tries to convert the given `Float` to a percentage string `…%`, after multiplying by 100.
    ///
    /// - Parameters:
    ///   - value: the `Float` value to convert
    /// - Returns: the rendered `String`
    /// - Throws: Filters.Error.invalidInputType if the value parameter isn't a float
    public static func percent(_ value: Any?) throws -> Any? {
      guard let value = value as? Float else { throw Filters.Error.invalidInputType }

      let percent = Int(value * 100.0)
      return "\(percent)%"
    }
  }
}
