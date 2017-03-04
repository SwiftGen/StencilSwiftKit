## Filter: "swiftIdentifier"

Transforms an arbitrary string into a valid Swift identifier (using only valid characters for a Swift identifier as defined in the Swift language reference). It will apply the following rules:

- Uppercase the first character.
- Prefix with an underscore if the first character is a number.
- Replace invalid characters by an underscore (`_`).

The list of allowed characters can be found here:
https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html

| Input    | Output                      |
|----------|-----------------------------|
| hello    | Hello                       |
| 42hello  | _42hello                    |
| some$URL | Some_URL                    |

## Filter: "lowerFirstWord"

Transforms an arbitrary string so that only the first "word" is lowercased.

- If the string starts with only one uppercase letter, lowercase that first letter.
- If the string starts with multiple uppercase letters, lowercase those first letters up to the one before the last uppercase one, but only if the last one is followed by a lowercase character.

| Input        | Output                   |
|--------------|--------------------------|
| PeoplePicker | peoplePicker             |
| URLChooser   | urlChooser               |
