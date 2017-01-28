# StencilSwiftKit CHANGELOG

---

## Master (to be 5.0.0)

### Bug Fixes

### New Features

* Added support for Swift Package Manager.  
  [Krzysztof Zabłocki](https://github.com/krzysztofzablocki)
  [#15](https://github.com/SwiftGen/StencilSwiftKit/issues/15)

### Internal Changes

* Renamed `SwiftTemplate` to `StencilSwiftTemplate`.  
  [David Jennes](https://github.com/djbe)
  [#14](https://github.com/SwiftGen/StencilSwiftKit/issues/14)
* Refactor stencil swift extensions registration for easier use with an existing `Extension`.  
  [David Jennes](https://github.com/djbe)
  [#16](https://github.com/SwiftGen/StencilSwiftKit/issues/16)

## Before 5.0.0

This first version of `StencilSwiftKit` is numbered `5.0.0` because it's the result of splitting the parts of `SwiftGen` into separate frameworks during its `5.0.0` release. This way, all parts of SwiftGen will start up with matching versions.

`StencilSwiftKit` is the framework used by SwiftGen to extend the Stencil template engine with nodes and filters specialized in generating Swift code. It is used at least by both `SwiftGen` and `Sourcery`, as both tools use Stencil templates to generate Swift code.

_For the list of older `CHANGELOG` history, see SwiftGen's own `CHANGELOG` for changes listed before `5.0.0` and before SwiftGen was split in separate frameworks._
