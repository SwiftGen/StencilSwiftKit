# StencilSwiftKit CHANGELOG

---

## Master

Due to the removal of legacy code, there are a few breaking changes in this new version that affect both template writers as well as developers. We've provided a migration guide to help you through these changes, which you can find here:
[Migration Guide for 2.0](https://github.com/SwiftGen/StencilSwiftKit/blob/master/Documentation/MigrationGuide.md#stencilswiftkit-20-swiftgen-50)

### Bug Fixes

* Fix `snakeToCamelCase` parameters information in README.  
  [Liquidsoul](https://github.com/Liquidsoul)
  [#45](https://github.com/SwiftGen/StencilSwiftKit/pulls/45)

### Breaking Changes

* The `ParametersError` enum has been replaced by the `Parameters.Error` nested type.  
  [Olivier Halligon](https://github.com/AliGator)
  [#37](https://github.com/SwiftGen/SwiftGenKit/pulls/37)
* The `FilterError` enum has been replaced by the `Filters.Error` nested type.  
  [Olivier Halligon](https://github.com/AliGator)
  [#37](https://github.com/SwiftGen/SwiftGenKit/pulls/37)
* The filters in `StringFilters` and `NumFilters` are now located under `Filters.Strings` and `Filters.Numbers`.  
  [Olivier Halligon](https://github.com/AliGator)
  [#40](https://github.com/SwiftGen/SwiftGenKit/pulls/40)
* Removed the `join` filter, as it's now integrated in `Stencil` proper.  
  [David Jennes](https://github.com/djbe)
  [#10](https://github.com/SwiftGen/StencilSwiftKit/pull/10)
* Refactored the `snakeToCamelCase` filter to now accept an (optional) boolean parameter to control the `noPrefix` behaviour.  
  [David Jennes](https://github.com/djbe)
  [#41](https://github.com/SwiftGen/StencilSwiftKit/pull/41)

### New Features

_None_

### Internal Changes

_None_

## 1.0.2

### Bug Fixes

* The context enrich function won't overwrite existing values in the `env` and `param` variables.  
  [David Jennes](https://github.com/djbe)
  [#29](https://github.com/SwiftGen/SwiftGenKit/issues/29)

### New Features

* Added camelToSnakeCase filter.  
  [Gyuri Grell](https://github.com/ggrell)
  [#24](https://github.com/SwiftGen/StencilSwiftKit/pull/24)

### Internal Changes

* Further refactor the Rakefile into rakelibs, and add a Gemfile for gem dependencies.  
  [David Jennes](https://github.com/djbe)
  [#28](https://github.com/SwiftGen/SwiftGenKit/issues/28)
  [#31](https://github.com/SwiftGen/SwiftGenKit/issues/31)
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
  [#20](https://github.com/SwiftGen/SwiftGenKit/issues/20)
  [#25](https://github.com/SwiftGen/SwiftGenKit/issues/25)
* Fixed SPM dependency in `Package.swift`.  
  [Krzysztof Zabłocki](https://github.com/krzysztofzablocki)
  [#26](https://github.com/SwiftGen/StencilSwiftKit/pull/26/files)

## 1.0.0

### Bug Fixes

_None_

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
