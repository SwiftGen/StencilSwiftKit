# Filters

This is a list of filters that are added by StencilSwiftKit on top of the filters already provided by Stencil (which you can [find here](http://stencil.fuller.li/en/latest/builtins.html#built-in-filters)).

## Filter: `int255toFloat`

Accepts an integer and divides it by 255, resulting in a floating point number (usually) between 0.0 and 1.0.

| Input | Output  |
|-------|---------|
| 240   | 0.9412  |
| 128   | 0.5019  |

## Filter: "hexToInt"

Accepts a string with a number in hexadecimal format, and converts it into an integer number. Note that the string should NOT be prefixed with `0x`.

| Input    | Output    |
|----------|-----------|
| FC       | 252       |
| fcFf     | 64767     |
| 01020304 | 16909060  |
| 0x1234   | nil / ""  |

## Filter: "percent"

Accepts a floating point number and multiplies it by 100. The result is truncated into an integer, converted into a string and appended with the `%` character.

| Input  | Output  |
|--------|---------|
| 0.23   | 23%     |
| 0.779  | 77%     |
| 1.234  | 123%    |
