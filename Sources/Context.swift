//
//  Context.swift
//  Pods
//
//  Created by David Jennes on 14/02/2017.
//
//

import Foundation

public enum StencilContext {
  public static let environment = "env"
  public static let parameters = "param"

  /**
   Enriches a stencil context with parsed parameters and environment variables
   
   - Parameter context: The stencil context
   - Parameter parameters: List of strings, will be parsed using the `Parameters.parse(items:)` method
   - Parameter environment: Environment variables, defaults to `ProcessInfo().environment`
   */
  public static func enrich(context: [String: Any],
                            parameters: [String],
                            environment: [String: String] = ProcessInfo().environment) throws -> [String: Any] {
    var context = context

    context[self.environment] = merge(context[self.environment], with: environment)
    context[self.parameters] = merge(context[self.parameters], with: try Parameters.parse(items: parameters))

    return context
  }

  private static func merge(_ lhs: Any?, with rhs: [String: Any]) -> [String: Any] {
    var result = lhs as? [String: Any] ?? [:]

    for (key, value) in rhs {
      result[key] = value
    }

    return result
  }
}
