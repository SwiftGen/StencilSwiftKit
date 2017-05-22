## StencilSwiftKit 2.0 (SwiftGen 5.0) ##

### For template writers:

* We've removed our `join` array filter as Stencil provides it's own version that accepts a parameter. If you were using StencilSwiftKit's version, replace instances of:  
```{{ myArray|join }}```  
with:  
```{{ myArray|join:", " }}```
* We've refactored our `snakeToCamelCase` to accept arguments, thus removing the need for `snakeToCamelCaseNoPrefix`. If you were using the latter, replace instances of:  
```{{ myValue|snakeToCamelCaseNoPrefix }}```  
with:  
```{{ myValue|snakeToCamelCase:true }}```

### For developers using StencilSwiftKit as a dependency:

We've removed the following deprecated `typealias`es:

* `FilterError`: use `Filters.Error` instead.
* `ParametersError`: use `Parameters.Error` instead.
* `NumFilters`: use `Filters.Numbers` instead.
* `StringFilters`: use `Filters.Strings` instead.
