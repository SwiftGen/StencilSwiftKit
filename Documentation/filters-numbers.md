# Filters

This is a list of filters that are added by StencilSwiftKit on top of the filters already provided by Stencil (which you can [find here](http://stencil.fuller.li/en/latest/builtins.html#built-in-filters)).

## Filter: "int255toFloat"

Accepts an integer and divides it by 255, resulting in a floating point number (usually) between 0.0 and 1.0.

## Filter: "hexToInt"

Accepts a string with a number in hexadecimal format, and converts it into an integer number.

## Filter: "percent"

Accepts a floating point number and multiplies it by 100. The result is converted into a string appended with the `%` character.
