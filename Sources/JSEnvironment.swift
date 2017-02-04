//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Stencil
import JavaScriptCore

public extension Extension {
    @discardableResult
    private func inJSContext<T>(_ jsContext: JSContext, _ block: () -> T) throws -> T {
        let result = block()
        if let exception = jsContext.exception {
            throw JSException(description: "\(exception)")
        } else {
            return result
        }
    }
    
    public func registerJSFilter(_ name: String, code: String) {
        self.registerFilter(name, filter: { [unowned self] (value: Any?, params: [Any?]) throws -> Any? in
            guard let value = value else { return nil }
            let jsContext = JSContext()!
            try self.inJSContext(jsContext) { jsContext.evaluateScript(code) }
            let tag = try self.inJSContext(jsContext) { jsContext.objectForKeyedSubscript(name) }
            let result = try self.inJSContext(jsContext) { tag?.call(withArguments: [value, params]) }
            return result?.toObject()
        })
    }
    
}

struct JSException: Error, CustomStringConvertible {
    let _description: String
    var description: String {
        return _description
    }
    init(description: String) {
        _description = description
    }
}
