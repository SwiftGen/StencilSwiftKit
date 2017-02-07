//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil
import JavaScriptCore

@discardableResult
private func inJSContext(_ jsContext: JSContext, _ block: () -> JSValue?) throws -> JSValue? {
    let result = block()
    if let exception = jsContext.exception {
        throw JSException(exception)
    } else {
        return result
    }
}

private func bridgingError<T>(_ expression: () throws -> T) -> T? {
    do {
        return try expression()
    } catch {
        JSContext.current().evaluateScript("throw \"\(error)\"")
        return nil
    }
}

struct JSException: Error, CustomStringConvertible {
    let exception: JSValue
    var description: String {
        return "\(exception)"
    }
    init(_ exception: JSValue) {
        self.exception = exception
    }
}

public extension Extension {
    
    /**
     Registers JavaScript function as a filter. Function should have the same name as `name` parameter,
     should accept two parameters for value and filter parameters (can be empty)
     and can return any object.
     
     - parameters:
        - name: filter's name
        - code: JavaScript code for filter
     
     Example:
     ```
     var uppercase = function(value, params) { 
        return value.toUpperCase() 
     }
     ```
     */
    public func registerJSFilter(_ name: String, code: String) {
        self.registerFilter(name, filter: { (value: Any?, params: [Any?]) throws -> Any? in
            guard let value = value else { return nil }
            let jsContext = JSContext()!
            try inJSContext(jsContext) { jsContext.evaluateScript(code) }
            let filter = try inJSContext(jsContext) { jsContext.objectForKeyedSubscript(name) }
            let result = try inJSContext(jsContext) { filter?.call(withArguments: [value, params]) }
            return result?.toObject()
        })
    }

    /**
     Registers JavaScript function as a simple tag. Function should have the same name as `name` parameter,
     should accept singe parameters for context and should return a string.
     
     - parameters:
        - name: filter's name
        - code: JavaScript code for tag
     
     Example:
     ```
     var greet = function(context) { 
        return \"Hello, \" + context.valueForKey('name') 
     }
     ```
     */
    public func registerJSSimpleTag(_ name: String, code: String) {
        self.registerSimpleTag(name) { (context) -> String in
            let jsContext = JSContext()!
            try inJSContext(jsContext) { jsContext.evaluateScript(code) }
            let tag = try inJSContext(jsContext) { jsContext.objectForKeyedSubscript(name) }
            let result = try inJSContext(jsContext) { tag?.call(withArguments: [JSStencilContext(context)]) }
            return result?.toString() ?? ""
        }
    }
    
    /**
     Registers JavaScript object as a tag. Object should have the same name as `name` parameter,
     should be constructed with two parameters for parser and token and should define function `render`
     to render its content that should accept single parameter for context and should return string.
     
     - parameters:
     - name: filter's name
     - code: JavaScript code for tag
     
     Example:
     ```
     function greet(parser, token) {
        // user pareser and token to parse tag
     
        this.render = function(context) {
           // return rendered content as a string
        }
     }
     ```
     */
    public func registerJSTag(_ name: String, code: String) {
        self.registerTag(name, parser: { parser, token in
            let jsContext = JSContext()!
            
            let newVariable: @convention(block) (String) -> JSResolvable = JSResolvable.init
            jsContext.setObject(unsafeBitCast(newVariable, to: AnyObject.self), forKeyedSubscript: "Variable" as NSString)
            
            let newVariableNode: @convention(block) (JSResolvable) -> (JSVariableNode) = JSVariableNode.init
            jsContext.setObject(unsafeBitCast(newVariableNode, to: AnyObject.self), forKeyedSubscript: "VariableNode" as NSString)
            
            jsContext.setObject(unsafeBitCast(renderNodes, to: AnyObject.self), forKeyedSubscript: "renderNodes" as NSString)
            
            try inJSContext(jsContext) { jsContext.evaluateScript(code) }
            let prototype = try inJSContext(jsContext) { jsContext.objectForKeyedSubscript(name) }
            let node = try inJSContext(jsContext) { prototype?.construct(withArguments: [JSTokenParser(parser), JSToken(token)]) }
            return JSNode(node, context: jsContext)
        })
    }
    
}

@objc protocol JSExportableTokenParser: JSExport {
    func parse() -> [JSNode]
    func nextToken() -> JSToken?
    func compileFilter(_ token: String) -> JSResolvable!
    func parse_until(_ tags: [String]?) -> [JSNode]
}

/// JS wrapper for TokenParser to access basic parser functionality from JS
class JSTokenParser: NSObject, JSExportableTokenParser {
    let parser: TokenParser
    init(_ parser: TokenParser) {
        self.parser = parser
    }

    func parse() -> [JSNode] {
        return parse_until(nil)
    }
    
    func parse_until(_ tags: [String]?) -> [JSNode] {
        return bridgingError {
            try parser.parse(tags.map(until)).map(JSNode.init)
            } ?? []
    }
    
    func nextToken() -> JSToken? {
        return parser.nextToken().map(JSToken.init)
    }
    
    func compileFilter(_ token: String) -> JSResolvable? {
        return bridgingError { try JSResolvable(parser.compileFilter(token)) }
    }

}

@objc protocol JSExportableToken: JSExport {
    func components() -> [String]
    var contents: String { get }
}

/// JS wrapper for Token 
class JSToken: NSObject, JSExportableToken {
    let token: Token
    init(_ token: Token) {
        self.token = token
    }
    
    func components() -> [String] {
        return token.components()
    }
    
    var contents: String {
        return token.contents
    }
    
}

@objc protocol JSExportableContext: JSExport {
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
    func push(_ closure: JSValue) -> Any
    func push(_ dictionary: [String: Any], _ closure: JSValue) -> Any
}

/// JS wrapper for Context to access subscript and push new contexts from JS
class JSStencilContext: NSObject, JSExportableContext {
    let context: Context
    init(_ context: Context) {
        self.context = context
    }
    
    override func value(forKey key: String) -> Any? {
        return context[key]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        context[key] = value
    }

    func push(_ closure: JSValue) -> Any {
        return context.push() { () -> Any in
            return closure.call(withArguments: [])
        }
    }

    func push(_ dictionary: [String: Any], _ closure: JSValue) -> Any {
        return context.push(dictionary: dictionary) { () -> Any in
            return closure.call(withArguments: [])
        }
    }
    
}

@objc protocol JSExportableResolvable: JSExport {
    func resolve(_ context: JSStencilContext) -> Any?
}

/// JS wrapper for Resolvable to wrap Variable and FilterExpression (which is private)
class JSResolvable: NSObject, JSExportableResolvable {
    let resolvable: Resolvable
    init(_ resolvable: Resolvable) {
        self.resolvable = resolvable
    }

    init(_ variable: String) {
        self.resolvable = Variable(variable)
    }

    func resolve(_ context: JSStencilContext) -> Any? {
        return bridgingError { try resolvable.resolve(context.context) as Any }
    }

}

@objc protocol JSExportableVariableNode: JSExport {
    func render(_ context: JSStencilContext) -> String?
}

/// JS wrapper for VariableNode
class JSVariableNode : NSObject, JSExportableVariableNode {
    let node: VariableNode
    
    init(_ resolvable: JSResolvable) {
        self.node = VariableNode(variable: resolvable.resolvable)
    }
    
    func render(_ context: JSStencilContext) -> String? {
        return bridgingError { try node.render(context.context) }
    }
}

/// JS wrapper for NodeType that represents node object written in JS.
/// Must have a method `render(JSStencilContext)` returning `string` of rendered content.
class JSNode: NSObject, NodeType {
    let value: JSValue?
    let node: NodeType?
    let context: JSContext?
    
    init(_ value: JSValue?, context: JSContext) {
        self.value = value
        self.node = nil
        self.context = context
    }
    
    init(_ node: NodeType) {
        self.node = node
        self.value = nil
        self.context = nil
    }
    
    func render(_ context: Context) throws -> String {
        if let value = value, let jsContext = self.context  {
            let result = try inJSContext(jsContext) { value.invokeMethod("render", withArguments: [JSStencilContext(context)]) }
            return result?.toString() ?? ""
        } else if let node = node {
            return try node.render(context)
        } else {
            return ""
        }
    }
}

/// Renders collection of nodes using provided context
private let renderNodes: @convention(block) ([JSNode], JSStencilContext) -> String? = { nodes, context in
    return bridgingError { try nodes.map({ try $0.render(context.context) }).joined(separator: "") }
}
