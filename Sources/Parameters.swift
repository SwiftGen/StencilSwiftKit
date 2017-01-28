//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

public enum ParametersError: Error {
  case invalidSyntax(value: String)
  case invalidKey(key: String, value: String)
  case invalidStructure(key: String, oldValue: Any, newValue: Any)
}

public enum Parameters {
  typealias Parameter = (key: String, value: String)
  public typealias StringDict = [String: Any]
  
  public static func parse(items: [String]) throws -> StringDict {
    let parameters: [Parameter] = try items.map { item in
      let parts = item.components(separatedBy: "=")
      guard parts.count == 2 else { throw ParametersError.invalidSyntax(value: item) }
      return (key: parts[0], value: parts[1])
    }
    
    var result = StringDict()
    for parameter in parameters {
      result = try parse(item: parameter, result: result)
    }
    
    return result
  }
  
  private static func parse(item: Parameter, result: StringDict) throws -> StringDict {
    let parts = item.key.components(separatedBy: ".")
    let key = parts.first ?? ""
    
    var result = result
    
    // validate key
    guard validate(key: key) else { throw ParametersError.invalidKey(key: item.key, value: item.value) }
    
    // no sub keys, may need to convert to array if repeat key if possible
    if parts.count == 1 {
      if let current = result[key] as? [String] {
        result[key] = current + [item.value]
      } else if let current = result[key] as? String {
        result[key] = [current, item.value]
      } else if let current = result[key] {
        throw ParametersError.invalidStructure(key: key, oldValue: current, newValue: item.value)
      } else {
        result[key] = item.value
      }
    } else if parts.count > 1 {
      guard result[key] is StringDict || result[key] == nil else {
        throw ParametersError.invalidStructure(key: key, oldValue: result[key], newValue: item.value)
      }
      
      // recurse into sub keys
      let current = result[key] as? StringDict ?? StringDict()
      let sub = (key: parts.suffix(from: 1).joined(separator: "."), value: item.value)
      result[key] = try parse(item: sub, result: current)
    }
    
    return result
  }
  
  // a valid key is not empty and only alphanumerical
  private static func validate(key: String) -> Bool {
    return !key.isEmpty &&
      key.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
  }
}
