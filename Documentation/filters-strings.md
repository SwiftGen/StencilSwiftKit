# Filters

This is a list of filters that are added by StencilSwiftKit on top of the filters already provided by Stencil (which you can [find here](http://stencil.fuller.li/en/latest/builtins.html#built-in-filters)).

## Filter: "escapeReservedKeywords"

Checks if the given string matches a reserved Swift keyword. If it does, wrap the string in escape characters.

| Input | Output                          |
|-------|---------------------------------|
| hello | hello                           |
| self  | \`self\`                        |
| Any   | \`Any\`                         |

## Filter: "lowerFirstWord"

Transforms an arbitrary string so that only the first "word" is lowercased.

- If the string starts with only one uppercase character, lowercase that first character.
- If the string starts with multiple uppercase character, lowercase those first characters up to the one before the last uppercase one, but only if the last one is followed by a lowercase character.

| Input        | Output                   |
|--------------|--------------------------|
| PeoplePicker | peoplePicker             |
| URLChooser   | urlChooser               |

## Filter: "snakeToCamelCase"

Transforms a string in "snake_case" format into one in "camelCase" format, following the steps below:

- Separate the string in components using the `_` as separator.
- For each component, uppercase the first character and do not touch the other characters in the component.
- Join the components again into one string.

If the whole starting "snake_case" string only contained uppercase characters, then each component will be capitalized: uppercase the first character and lowercase the other characters.

| Input        | Output                   |
|--------------|--------------------------|
| snake_case   | SnakeCase                |
| snAke_case   | SnAkeCase                |
| SNAKE_CASE   | SnakeCase                |
| __snake_case | __SnakeCase              |

This filter accepts a parameter (boolean, default `false`) that controls the prefixing behaviour. If set to `true`, it will trim empty components from the beginning of the string

| Input        | Output                   |
|--------------|--------------------------|
| snake_case   | SnakeCase                |
| snAke_case   | SnAkeCase                |
| SNAKE_CASE   | SnakeCase                |
| __snake_case | SnakeCase                |

## Filter: "swiftIdentifier"

Transforms an arbitrary string into a valid Swift identifier (using only valid characters for a Swift identifier as defined in the Swift language reference). It will apply the following rules:

- Uppercase the first character.
- Prefix with an underscore if the first character is a number.
- Replace invalid characters by an underscore (`_`).

The list of allowed characters can be found here:
https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html

| Input    | Output                       |
|----------|------------------------------|
| hello    | Hello                        |
| 42hello  | _42hello                     |
| some$URL | Some_URL                     |

## Filter: "titlecase"

Simply uppercases the first characters. Different from the `capitalized` filter, which upercases the first characters and lowercases the remaining characters.

| Input         | Output                  |
|---------------|-------------------------|
| hello         | Hello                   |
| peopleChooser | PeopleChooser           |
