//
// StencilSwiftKit
// Copyright (c) 2017 Olivier Halligon
// MIT Licence
//

import Foundation
import PathKit
import XCTest

private let colorCode: (String) -> String =
  ProcessInfo.processInfo.environment["XcodeColors"] == "YES" ? { "\u{001b}[\($0);" } : { _ in "" }
private let (msgColor, reset) = (colorCode("fg250,0,0"), colorCode(""))
private let okCode = (num: colorCode("fg127,127,127"),
                      code: colorCode(""))
private let koCode = (num: colorCode("fg127,127,127") + colorCode("bg127,0,0"),
                      code: colorCode("fg250,250,250") + colorCode("bg127,0,0"))

func diff(_ result: String, _ expected: String) -> String? {
  guard result != expected else { return nil }
  var firstDiff: Int? = nil
  let nl = CharacterSet.newlines
  let lhsLines = result.components(separatedBy: nl)
  let rhsLines = expected.components(separatedBy: nl)

  for (idx, pair) in zip(lhsLines, rhsLines).enumerated() where pair.0 != pair.1 {
    firstDiff = idx
    break
  }
  if let badLineIdx = firstDiff {
    let slice = { (lines: [String], context: Int) -> ArraySlice<String> in
      let start = max(0, badLineIdx - context)
      let end = min(badLineIdx + context, lines.count - 1)
      return lines[start...end]
    }
    let addLineNumbers = { (slice: ArraySlice) -> [String] in
      slice.enumerated().map { (idx: Int, line: String) in
        let num = idx + slice.startIndex
        let lineNum = "\(num + 1)".padding(toLength: 3, withPad: " ", startingAt: 0) + "|"
        let clr = num == badLineIdx ? koCode : okCode
        return "\(clr.num)\(lineNum)\(reset)\(clr.code)\(line)\(reset)"
      }
    }
    let lhsNum = addLineNumbers(slice(lhsLines, 4)).joined(separator: "\n")
    let rhsNum = addLineNumbers(slice(rhsLines, 4)).joined(separator: "\n")
    return [
      "\(msgColor)Mismatch at line \(badLineIdx)\(reset)",
      ">>>>>> result",
      "\(lhsNum)",
      "======",
      "\(rhsNum)",
      "<<<<<< expected"
    ].joined(separator: "\n")
  }
  return nil
}

func XCTDiffStrings(_ result: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
  guard let error = diff(result, expected) else { return }
  XCTFail(error, file: file, line: line)
}

class Fixtures {
  private static let resources: Path = {
    if let path = Bundle(for: Fixtures.self).resourceURL?.path,
      Path(path).exists {
      return Path(path)
    } else {
      return Path(#file).parent() + "Resources"
    }
  }()
  private init() {}

  static func directory(subDirectory subDir: String? = nil) -> Path {
    guard let dir = subDir else { return resources }
    return resources + dir
  }

  static func path(for name: String, subDirectory: String? = nil) -> Path {
    if let subDirectory = subDirectory {
      return resources + subDirectory + name
    } else {
      return resources + name
    }
  }

  static func string(for name: String, encoding: String.Encoding = .utf8) -> String {
    let subDir: String? = name.hasSuffix(".stencil") ? "fixtures" : "expected"
    do {
      return try path(for: name, subDirectory: subDir).read(encoding)
    } catch let error {
      fatalError("Unable to load fixture content: \(error)")
    }
  }
}
