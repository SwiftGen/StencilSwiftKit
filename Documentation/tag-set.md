# Tag: "Set"

This tag stores a value into a variable for later use.

## Node Information

| Name      | Description                      |
|-----------|----------------------------------|
| Tag Name  | `set`                            |
| End Tag   | `endset`                         |
| Rendering | Immediately; no output           |
| Example   | {% set myVar %}hello{% endset %} |


| Parameter | Description                                 | 
|-----------|---------------------------------------------|
| Name      | The name of the variable you want to store. |

## When to use it

Useful when you have a certain calculation you want to re-use in multiple places without repeating yourself. For example you can compute only once the result of multiple filters applied in sequence to a variable, store that result and reuse it later.

The content between the the `set` and `endset` tags is rendered immediately using the available context, and stored on the stack into a variable with the provided name.

Keep in mind that the variable is scoped, meaning that if you set a variable while (for example) inside a for loop, the set variable will not exist outside the scope of that for loop.

## Usage example

```stencil
// we start with 'x' and 'y' as empty variables

// set value
{% set x %}hello{% endset %} 
{% set y %}world{% endset %}
// x = "hello", y = "world"

// Compute some complex expression once, and reuse it multiple times later
{% set greetings %}{{ x|uppercase }}, {{ y|titlecase }}{% endset %}
// greetings = "HELLO, World"

// set inside for loop
{% for item in items %}
  {% set x %}item #{{item}}{% endset %}
  // x = "item #...", y = "world"
  // greetings is still = "HELLO, World" (it isn't recomputed with new x)
{% endfor %}

// after for loop
// x = "hello", y = "world"

{{ greetings }}, {{ greetings }}, {{ greetings }}!
// HELLO World, HELLO World, HELLO World!
```
