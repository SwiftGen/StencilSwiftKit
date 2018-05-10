//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil

class SetNode: NodeType {
  enum Content {
    case nodes([NodeType])
    case value(Resolvable)
  }

  let variableName: String
  let content: Content

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components()
    guard components.count <= 3 else {
      throw TemplateSyntaxError("""
        'set' tag takes at least one argument (the name of the variable to set) \
        and optionally the value expression.
        """)
    }

    let variable = components[1]
    if components.count == 3 {
      // we have a value expression, no nodes
      let value = try parser.compileFilter(components[2])
      return SetNode(variableName: variable, content: .value(value))
    } else {
      // no value expression, parse until an `endset` node
      let setNodes = try parser.parse(until(["endset"]))

      guard parser.nextToken() != nil else {
        throw TemplateSyntaxError("`endset` was not found.")
      }

      return SetNode(variableName: variable, content: .nodes(setNodes))
    }
  }

  init(variableName: String, content: Content) {
    self.variableName = variableName
    self.content = content
  }

  func render(_ context: Context) throws -> String {
    switch content {
    case .nodes(let nodes):
      let result = try renderNodes(nodes, context)
      context[variableName] = result
    case .value(let value):
      context[variableName] = try value.resolve(context)
    }

    return ""
  }
}
