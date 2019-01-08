# StencilSwiftKit CHANGELOG

---

## Master

### Breaking Changes

_None_

### New Features

_None_

### Bug Fixes

* `Parameters`: ensure the `flatten` function correctly handles a flag with a `false` value.  
  [David Jennes](https://github.com/djbe)
  [#108](https://github.com/SwiftGen/StencilSwiftKit/pull/108)

### Internal Changes

* Update to SwiftLint 0.29.3 and enable some extra SwiftLint rules.  
  [David Jennes](https://github.com/djbe)
  [#112](https://github.com/SwiftGen/StencilSwiftKit/pull/112)

## 2.7.1

### Bug Fixes

* `swiftIdentifier`: fix crash on empty string.  
  [David Jennes](https://github.com/djbe)
  [#105](https://github.com/SwiftGen/StencilSwiftKit/pull/105)

## 2.7.0

### New Features

* Updated Stencil to the latest version (0.13).  
  [David Jennes](https://github.com/djbe)
  [#103](https://github.com/SwiftGen/StencilSwiftKit/pull/103)

### Internal Changes

* Improved the documentation of string filters a bit for a better overview of the inputs & outputs.  
  [David Jennes](https://github.com/djbe)
  [#102](https://github.com/SwiftGen/StencilSwiftKit/pull/102)
* Updated to latest Xcode (10.0).  
  [David Jennes](https://github.com/djbe)
  [#103](https://github.com/SwiftGen/StencilSwiftKit/pull/103)

## 2.6.0

### New Features

* The `set` tag can now directly accept an expression as value, see the
  [documentation](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/tag-set.md)
  for an explanation on how this differs with the normal `set`/`endset`
  pair.  
  [David Jennes](https://github.com/djbe)
  [#87](https://github.com/SwiftGen/StencilSwiftKit/pull/87)
* Updated Stencil to the latest version (0.12.1).  
  [David Jennes](https://github.com/djbe)
  [#95](https://github.com/SwiftGen/StencilSwiftKit/pull/95)
  [#99](https://github.com/SwiftGen/StencilSwiftKit/pull/99)

### Bug fixes

* Fixed using filter expression in call node.  
  [Ilya Puchka](https://github.com/ilyapuchka)
  [#85](https://github.com/SwiftGen/StencilSwiftKit/pull/85)
* Fixed compilation issue with Xcode 10 & Swift 4.2 by adding hints to help the compiler.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#93](https://github.com/SwiftGen/StencilSwiftKit/pull/93)
* Migrated to PathKit for url filters. The dirname will return '.' for a filename without base directory.  
  [Rahul Katariya](https://github.com/RahulKatariya)
  [Philip Jander](https://github.com/janderit)
  [#94](https://github.com/SwiftGen/StencilSwiftKit/pull/94)

### Internal Changes

* Updated to latest Xcode (9.3.0).  
  [David Jennes](https://github.com/djbe)
  [#86](https://github.com/SwiftGen/StencilSwiftKit/pull/86)
* Update to SwiftLint 0.27 and enable some extra SwiftLint rules.  
  [David Jennes](https://github.com/djbe)
  [#96](https://github.com/SwiftGen/StencilSwiftKit/pull/96)
* Test Linux SPM support in CI.  
  [David Jennes](https://github.com/janderit)
  [#90](https://github.com/SwiftGen/StencilSwiftKit/pull/90)

## 2.5.0

### New Features

* Updated Stencil to the latest version (0.11.0).  
  [David Jennes](https://github.com/djbe)
  [#83](https://github.com/SwiftGen/StencilSwiftKit/pull/83)

### Internal Changes

* Switched to using SwiftLint via CocoaPods instead of our own install scripts.  
  [David Jennes](https://github.com/djbe)
  [#78](https://github.com/SwiftGen/StencilSwiftKit/pull/78)
* Enabled some extra SwiftLint rules for better code consistency.  
  [David Jennes](https://github.com/djbe)
  [#79](https://github.com/SwiftGen/StencilSwiftKit/pull/79)
* Migrated to CircleCI 2.0.  
  [David Jennes](https://github.com/djbe)
  [#81](https://github.com/SwiftGen/StencilSwiftKit/pull/81)
* Migrated to Swift 4, and dropped support for Swift 3.  
  [David Jennes](https://github.com/djbe)
  [#80](https://github.com/SwiftGen/StencilSwiftKit/pull/80)

## 2.4.0

### New Features

* Add `!` counterpart for strings boolean filters.  
  [Antondomashnev](https://github.com/antondomashnev)
  [#68](https://github.com/SwiftGen/StencilSwiftKit/pull/68)
* Updated Stencil to the latest version (0.10.1).  
  [Ilya Puchka](https://github.com/ilyapuchka)
  [#73](https://github.com/SwiftGen/StencilSwiftKit/pull/73)

## 2.3.0

### New Features

* Added `Parameters.flatten(dictionary:)` method to do the opposite of
  `Parameters.parse(items:)` and turn a dictionary into the list of parameters to pass from the command line.  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#70](https://github.com/SwiftGen/StencilSwiftKit/pull/70)

### Bug Fixes

* Workaround for `parseString` to support `NSString`.  
  [Antondomashnev](https://github.com/antondomashnev)
  [#68](https://github.com/SwiftGen/StencilSwiftKit/pull/68)

## 2.2.0

### New Features

* Accept `LosslessStringConvertible` input for strings filters.  
  [Antondomashnev](https://github.com/antondomashnev)
  [#65](https://github.com/SwiftGen/StencilSwiftKit/pull/65)
* `StencilContext.enrich` now also accept a Dictionary for specifying parameters
  (in preparation for supporting Config files in SwiftGen).  
  [Olivier Halligon](https://github.com/AliSoftware)
  [#66](https://github.com/SwiftGen/StencilSwiftKit/pull/66)

### Internal Changes

* Refactoring of `Filters+Strings`.  
  [Antondomashnev](https://github.com/antondomashnev)
  [#63](https://github.com/SwiftGen/StencilSwiftKit/pull/63)

## 2.1.0

### New Features

* Added the `basename` and `dirname` string filters for getting a filename, or parent folder (respectively), out of a path.  
  [David Jennes](https://github.com/djbe)
  [#60](https://github.com/SwiftGen/StencilSwiftKit/pull/60)
* Modify the `swiftIdentifier` string filter to accept an optional "pretty" mode, to also apply the `snakeToCamelCase` filter and other manipulations if needed for a "prettier" but still valid identifier.  
  [David Jennes](https://github.com/djbe)
  [#61](https://github.com/SwiftGen/StencilSwiftKit/pull/61)

### Internal Changes

* Ensure `swiftlint` is run using `bundler`.  
  [David Jennes](https://github.com/djbe)
  [#59](https://github.com/SwiftGen/StencilSwiftKit/pull/59)

## 2.0.1

* Fix compilation on Linux.  
  [JP Simard](https://github.com/jpsim)
  [#56](https://github.com/SwiftGen/StencilSwiftKit/pull/56)

## 2.0.0

Due to the removal of legacy code, there are a few breaking changes in this new version that affect both template writers as well as developers. We've provided a migration guide to help you through these changes, which you can find here:
[Migration Guide for 2.0](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/MigrationGuide.md#stencilswiftkit-20-swiftgen-50)

### Breaking Changes

* The `ParametersError` enum has been replaced by the `Parameters.Error` nested type.  
  [Olivier Halligon](https://github.com/AliGator)
  [#37](https://github.com/SwiftGen/StencilSwiftKit/issues/37)
* The `FilterError` enum has been replaced by the `Filters.Error` nested type.  
  [Olivier Halligon](https://github.com/AliGator)
  [#37](https://github.com/SwiftGen/StencilSwiftKit/issues/37)
* The filters in `StringFilters` and `NumFilters` are now located under `Filters.Strings` and `Filters.Numbers`.  
  [Olivier Halligon](https://github.com/AliGator)
  [#40](https://github.com/SwiftGen/StencilSwiftKit/issues/40)
* Removed the `join` filter, as it's now integrated in `Stencil` proper.  
  [David Jennes](https://github.com/djbe)
  [#10](https://github.com/SwiftGen/StencilSwiftKit/issues/10)
* Refactored the `snakeToCamelCase` filter to now accept an (optional) boolean parameter to control the `noPrefix` behaviour.  
  [David Jennes](https://github.com/djbe)
  [#41](https://github.com/SwiftGen/StencilSwiftKit/issues/41)
* Rename the `stringToSwiftIdentifier` function to `swiftIdentifier` to better match the other method names.  
  [David Jennes](https://github.com/djbe)
  [#46](https://github.com/SwiftGen/StencilSwiftKit/issues/46)

### New Features

* Added the `contains`, `replace`, `hasPrefix`, `hasSuffix`, `lowerFirstLetter` filters for strings.  
  [Antondomashnev](https://github.com/antondomashnev)
  [#54](https://github.com/SwiftGen/StencilSwiftKit/pull/54)
* Added the `removeNewlines` filter to remove newlines (and spaces) from a string.  
  [David Jennes](https://github.com/djbe)
  [#47](https://github.com/SwiftGen/StencilSwiftKit/issues/47)
  [#48](https://github.com/SwiftGen/StencilSwiftKit/issues/48)

### Bug Fixes

* Fix `snakeToCamelCase` parameters information in README.  
  [Liquidsoul](https://github.com/Liquidsoul)
  [#45](https://github.com/SwiftGen/StencilSwiftKit/issues/45)

## 1.0.2

### New Features

* Added camelToSnakeCase filter.  
  [Gyuri Grell](https://github.com/ggrell)
  [#24](https://github.com/SwiftGen/StencilSwiftKit/pull/24)

### Bug Fixes

* The context enrich function won't overwrite existing values in the `env` and `param` variables.  
  [David Jennes](https://github.com/djbe)
  [#29](https://github.com/SwiftGen/StencilSwiftKit/issues/29)

### Internal Changes

* Further refactor the Rakefile into rakelibs, and add a Gemfile for gem dependencies.  
  [David Jennes](https://github.com/djbe)
  [#28](https://github.com/SwiftGen/StencilSwiftKit/issues/28)
  [#31](https://github.com/SwiftGen/StencilSwiftKit/issues/31)
* Update Stencil to 0.9.0 and update project to Xcode 8.3.  
  [Diogo Tridapalli](https://github.com.diogot)
  [#32](https://github.com/SwiftGen/StencilSwiftKit/pull/32)
* Added documentation for tags and filters.  
  [David Jennes](https://github.com/djbe)
  [#12](https://github.com/SwiftGen/StencilSwiftKit/pull/12)

### Deprecations

* The `ParametersError` enum has been replaced by the `Parameters.Error` nested type.
  `ParametersError` still works (it is now `typealias`) but will be removed in the
  next major release.  
  [Olivier Halligon](https://github.com/AliGator)
* The `FilterError` enum has been replaced by the `Filters.Error` nested type.
  `FilterError` still works (it is now `typealias`) but will be removed in the
  next major release.  
  [Olivier Halligon](https://github.com/AliGator)

## 1.0.1

### Internal Changes

* Switch from Travis CI to Circle CI, clean up the Rakefile in the process.  
  [David Jennes](https://github.com/djbe)
  [#20](https://github.com/SwiftGen/StencilSwiftKit/issues/20)
  [#25](https://github.com/SwiftGen/StencilSwiftKit/issues/25)
* Fixed SPM dependency in `Package.swift`.  
  [Krzysztof Zabłocki](https://github.com/krzysztofzablocki)
  [#26](https://github.com/SwiftGen/StencilSwiftKit/pull/26/files)

## 1.0.0

### New Features

* Added support for Swift Package Manager.  
  [Krzysztof Zabłocki](https://github.com/krzysztofzablocki)
  [#15](https://github.com/SwiftGen/StencilSwiftKit/issues/15)
* Added `MapNode` to apply a `map` operator to an array.
  You can now use `{% map someArray into result using item %}`
  to do the equivalent of the `result = someArray.map { item in … }` Swift code.  
  [David Jennes](https://github.com/djbe)
  [#11](https://github.com/SwiftGen/StencilSwiftKit/pull/11)
* Add a "parameters parser" able to transform parameters passed as a set of strings
  (`a=1 b.x=2 b.y=3 c=4 c=5`) — typically provided as the command line arguments of a CLI
   — into a Dictionary suitable for Stencil contexts.  
  [David Jennes](https://github.com/djbe)
  [#8](https://github.com/SwiftGen/StencilSwiftKit/pull/8)
* Add a `StencilContext.enrich` function to enrich Stencil contexts with `param` and `env` dictionaries.  
  The `param` dictionary typically contains parameters parsed via the parameters parser above.  
  The `env` dictionary contains all the environment variables. You can thus access them in
  your templates using `env.USER`, `env.LANG`, `env.PRODUCT_MODULE_NAME`, etc.  
  [#19](https://github.com/SwiftGen/StencilSwiftKit/pull/19)

### Internal Changes

* Renamed `SwiftTemplate` to `StencilSwiftTemplate`.  
  [David Jennes](https://github.com/djbe)
  [#14](https://github.com/SwiftGen/StencilSwiftKit/issues/14)
* Refactor stencil swift extensions registration for easier use with an existing `Extension`.  
  [David Jennes](https://github.com/djbe)
  [#16](https://github.com/SwiftGen/StencilSwiftKit/issues/16)
* Refactor stencil node tests to not use templates and output files.  
  [David Jennes](https://github.com/djbe)
  [#17](https://github.com/SwiftGen/StencilSwiftKit/issues/17)

## Pre-1.0.0

_See SwitftGen's own CHANGELOG pre SwiftGen 4.2 version, before the refactoring that led us to split the code in frameworks_
