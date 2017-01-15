//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

public enum ParametersError: Error {
	case invalidSyntax(value: String)
	case invalidKey(key: String, value: String)
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
		var result = result
		
		// no sub keys, may need to convert to array if repeat key
		if parts.count == 1 {
			if let current = result[item.key] as? [String] {
				result[item.key] = current + [item.value]
			} else if let current = result[item.key] {
				result[item.key] = [current, item.value]
			} else {
				result[item.key] = item.value
			}
		} else if parts.count > 1 {
			// recurse into sub keys
			let part = parts.first ?? ""
			let sub = (key: parts.suffix(from: 1).joined(separator: "."), value: item.value)
			let current = result[part] as? StringDict ?? StringDict()
			
			result[part] = try parse(item: sub, result: current)
		} else {
			throw ParametersError.invalidKey(key: item.key, value: item.value)
		}
		
		return result
	}
}
