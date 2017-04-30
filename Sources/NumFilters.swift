//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

struct NumFilters {
  static func hexToInt(_ value: Any?) throws -> Any? {
    guard let value = value as? String else { throw FilterError.invalidInputType }
    return Int(value, radix:  16)
  }

  static func int255toFloat(_ value: Any?) throws -> Any? {
    guard let value = value as? Int else { throw FilterError.invalidInputType }
    return Float(value) / Float(255.0)
  }

  static func percent(_ value: Any?) throws -> Any? {
    guard let value = value as? Float else { throw FilterError.invalidInputType }

    let percent = Int(value * 100.0)
    return "\(percent)%"
  }
}
