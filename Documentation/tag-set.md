# Tag: "Set"

This tag stores a value into a variable for later use.

## Node Information

| Name      | Description                                                            |
|-----------|------------------------------------------------------------------------|
| Tag Name  | `set`                                                                  |
| End Tag   | `endset`  or N/A (if you're creating an alias of an existing variable) |
| Rendering | Immediately; no output                                                 |

| Parameter  | Description                                 | 
|------------|---------------------------------------------|
| Name       | The name of the variable you want to store. |
| Expression | (Optional) The value to be stored.          |

The parameters and tags of this node depend on which mode you want to use:

- Use `{% set myVar %}...{% endset %}` to render and store everything between the start and end tag into the variable.
- Use `{% set myVar someOtherVar.prop1.prop2 #}` to evaluate and store an expression's result into the variable.

_Example of render:_ `{% set myVar %}hello{% endset %}`

_Example of evaluate:_ `{% set myVar2 myVar|uppercase %}`

## When to use it

Useful when you have a certain calculation you want to re-use in multiple places without repeating yourself. For example you can compute only once the result of multiple filters applied in sequence to a variable, store that result and reuse it later.

This tag can be used in 2 ways:

- **Render**: the content between the the `set` and `endset` tags is rendered immediately using the available context, and stored on the stack into a variable with the provided name.
- **Evaluate**: the provided expression is evaluated and stored into a variable with the provided name. This is especially useful if you want to avoid the conversion of contents to a String value (which *render* mode always does).

Keep in mind that the variable is scoped, meaning that if you set a variable while (for example) inside a for loop, the set variable will not exist outside the scope of that for loop.

## Usage example

```stencil
// we start with 'x' and 'y' as empty variables
// 'items' is an array of integers in the context: [1, 3, 7]

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

// Difference between render and evaluate:

{% set a %}{{items}}{% endset %}
{% set b items %}
// a = "[1, 3, 7]", b = [1, 3, 7]
// a is contains a string (the description of 'items')
// b contains an array, the same value as 'items'

// This will print every character in the string "[1, 3, 7]"
{% for item in a %}
	item = {{item}}
{% endfor %}

// This will print every item of the array [1, 3, 7]
{% for item in b %}
	item = {{item}}
{% endfor %}
```
