# Filters

This is a list of filters that are added by StencilSwiftKit on top of the filters already provided by Stencil (which you can [find here](http://stencil.fuller.li/en/latest/builtins.html#built-in-filters)).

## Filter: `basename`

Get the last component of a path, essentially the filename (and extension).

| Input                  | Output         |
|------------------------|----------------|
| `test.jpg`             | `test.jpg`     |
| `some/folder/test.jpg` | `test.jpg`     |
| `file.txt.png`         | `file.txt.png` |

## Filter: `camelToSnakeCase`

Transforms text from camelCase to snake_case. The filter accepts an optional boolean parameter:

- **true** (default): Lowercase each component.
- **false**: Keep the casing for each component.

| Input                   | Output (`true`)         | Output (`false`)        |
|-------------------------|-------------------------|-------------------------|
| `SomeCapString`         | `some_cap_string`       | `Some_Cap_String`       |
| `someCapString`         | `some_cap_string`       | `some_Cap_String`       |
| `String_With_WoRds`     | `string_with_words`     | `String_With_Wo_Rds`    |
| `string_wiTH_WOrds`     | `st_ring_with_words`    | `string_wi_TH_W_Ords`   |
| `URLChooser`            | `url_chooser`           | `URL_Chooser`           |
| `PLEASE_STOP_SCREAMING` | `please_stop_screaming` | `PLEASE_STOP_SCREAMING` |

## Filter: `contains`

Checks if the string contains given substring - works the same as Swift's `String.contains`.

| Input             | Output  |
|-------------------|---------|
| `Hello` `el`      | `true`  |
| `Hi mates!` `yo`  | `false` |

## Filter: `dirname`

Remove the last component of a path, essentially returning the path without the filename (and extension).

| Input                  | Output        |
|------------------------|---------------|
| `test.jpg`             | ``            |
| `some/folder/test.jpg` | `some/folder` |
| `file.txt.png`         | ``            |

## Filter: `escapeReservedKeywords`

Checks if the given string matches a reserved Swift keyword. If it does, wrap the string in escape characters (backticks).

| Input   | Output       |
|---------|--------------|
| `hello` | `hello`      |
| `self`  | `` `self` `` |
| `Any`   | `` `Any` ``  |

## Filter: `hasPrefix`

Checks if the string has the given prefix - works the same as Swift's `String.hasPrefix`.

| Input             | Output  |
|-------------------|---------|
| `Hello` `Hi`      | `false` |
| `Hi mates!` `H`   | `true`  |

## Filter: `hasSuffix`

Checks if the string has the given suffix - works the same as Swift's `String.hasSuffix`.

| Input             | Output  |
|-------------------|---------|
| `Hello` `llo`     | `true`  |
| `Hi mates!` `?`   | `false` |

## Filter: `lowerFirstLetter`

Simply lowercases the first character, leaving the other characters untouched.

| Input           | Output          |
|-----------------|-----------------|
| `Hello`         | `hello`         |
| `PeopleChooser` | `peopleChooser` |
| `Hi There!`     | `hi There!`     |

## Filter: `lowerFirstWord`

Transforms an arbitrary string so that only the first "word" is lowercased.

- If the string starts with only one uppercase character, lowercase that first character.
- If the string starts with multiple uppercase character, lowercase those first characters up to the one before the last uppercase one, but only if the last one is followed by a lowercase character. This allows to support strings beginnng with an acronym, like `URL`.

| Input          | Output         |
|----------------|----------------|
| `PeoplePicker` | `peoplePicker` |
| `URLChooser`   | `urlChooser`   |

## Filter: `removeNewlines`

This filter has a couple of modes that you can specifiy using an optional mode argument:

- **all** (default): Removes all newlines and whitespace characters from the string.
- **leading**: Removes leading whitespace characters from each line, and all newlines. Also trims the end result.

| Input                  | Output (`all`)   | Output (leading)   |
|------------------------|------------------|--------------------|
| `  \ntest`             | `test`           | `test`             |
| `test \n\t `           | `test`           | `test`             |
| `test\n  test`         | `testtest`       | `testtest`         |
| `test, \ntest, \ntest` | `test,test,test` | `test, test, test` |
| ` test test `          | `testtest`       | `test test`        |

## Filter: `replace`

Replaces the given substring with the given replacement in the source string.
Works the same as Swift's `String.replacingOccurrences`.

| Input (search, replacement) | Output   |
|-----------------------------|----------|
| `Hello` (`l`, `k`)          | `Hekko`  |
| `Europe` (`e`, `a`)         | `Europa` |

## Filter: `snakeToCamelCase`

Transforms a string in "snake_case" format into one in "camelCase" format, following the steps below:

- Separate the string in components using the `_` as separator.
- For each component, uppercase the first character and do not touch the other characters in the component.
- Join the components again into one string.

If the whole starting "snake_case" string only contained uppercase characters, then each component will be capitalized: uppercase the first character and lowercase the other characters.

This filter accepts an optional boolean parameter that controls the prefixing behaviour:

- **false** (default): don't remove any empty components.
- **true**: trim empty components from the beginning of the string

| Input          | Output (false) | Output (true) |
|----------------|----------------|---------------|
| `snake_case`   | `SnakeCase`    | `SnakeCase`   |
| `snAke_case`   | `SnAkeCase`    | `SnAkeCase`   |
| `SNAKE_CASE`   | `SnakeCase`    | `SnakeCase`   |
| `__snake_case` | `__SnakeCase`  | `SnakeCase`   |

## Filter: `swiftIdentifier`

Transforms an arbitrary string into a valid Swift identifier (using only valid characters for a Swift identifier as defined in the Swift language reference). It will apply the following rules:

- Uppercase the first character.
- Prefix with an underscore if the first character is a number.
- Replace invalid characters by an underscore (`_`).

The list of allowed characters can be found here:
https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html

This filter has a couple of modes that you can specifiy using an optional mode argument:

- **normal** (default): apply the steps mentioned above (uppercase first, prefix if needed, replace invalid characters with `_`)
- **pretty**: Same as normal, but afterwards it will apply the `snakeToCamelCase` filter, and other manipulations, for a prettier (but still valid) identifier.

| Input                  | Output (normal)         | Output (pretty)      |
|------------------------|-------------------------|----------------------|
| `hello`                | `Hello`                 | `Hello`              |
| `42hello`              | `_42hello`              | `_42hello`           |
| `some$URL`             | `Some_URL`              | `SomeURL`            |
| `25 Ultra Light`       | `_25_Ultra_Light`       | `_25UltraLight`      |
| `26_extra_ultra_light` | `_26_extra_ultra_light` | `_26ExtraUltraLight` |
| `apples.count`         | `Apples_Count`          | `ApplesCount`        |
| `foo_bar.baz.qux-yay`  | `Foo_bar_Baz_Qux_Yay`   | `FooBarBazQuxYay`    |


## Filter: `titlecase`

Deprecated in favor of `upperFirstLetter`.

## Filter: `upperFirstLetter`

Simply uppercases the first character, leaving the other characters untouched.

Note that even if very similar, this filter differs from the `capitalized` filter, which uppercases the first character but also lowercases the remaining characters.

| Input           | Output          |
|-----------------|-----------------|
| `hello`         | `Hello`         |
| `peopleChooser` | `PeopleChooser` |
