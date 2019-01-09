//
// StencilSwiftKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Stencil

class ImportNode: NodeType {
  var token: Token?

  let templateName: Variable

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let bits = token.components()

    guard bits.count == 2 else {
      throw TemplateSyntaxError("'import' tag requires one argument, the template file to be imported.")
    }

    return ImportNode(templateName: Variable(bits[1]))
  }

  init(templateName: Variable) {
    self.templateName = templateName
  }

  func render(_ context: Context) throws -> String {
    guard let templateName = try self.templateName.resolve(context) as? String else {
      throw TemplateSyntaxError("'\(self.templateName)' could not be resolved as a string")
    }

    let template = try context.environment.loadTemplate(name: templateName)

    _ = try template.render(context.flatten())
    return ""
  }
}
