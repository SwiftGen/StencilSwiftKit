//
// StencilSwiftKit
// Copyright © 2022 SwiftGen
// MIT Licence
//

import Stencil

internal final class ImportNode: NodeType {
  let templateName: Variable
  let token: Token?

  class func parse(_ parser: TokenParser, token: Token) throws -> NodeType {
    let components = token.components
    guard components.count == 2 else {
      throw TemplateSyntaxError("'import' tag requires one argument, the template file to be imported.")
    }

    return ImportNode(templateName: Variable(components[1]), token: token)
  }

  init(templateName: Variable, token: Token? = nil) {
    self.templateName = templateName
    self.token = token
  }

  func render(_ context: Context) throws -> String {
    guard let templateName = try self.templateName.resolve(context) as? String else {
      throw TemplateSyntaxError("'\(self.templateName)' could not be resolved as a string")
    }

    let template = try context.environment.loadTemplate(name: templateName)
    _ = try template.render(context)

    // Import should never render anything
    return ""
  }
}
