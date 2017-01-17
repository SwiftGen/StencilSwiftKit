## Node Information

| Name      | Description                      |
|-----------|----------------------------------|
| Tag Name  | `set`                            |
| End Tag   | `endset`                         |
| Rendering | Directly, no output              |
| Example   | {% set myVar %}hello{% endset %} |


| Parameter | Description                                 | 
|-----------|---------------------------------------------|
| Name      | The name of the variable you want to store. |

## When to use it

Useful when you have a certain calculation you want to re-use in multiple
places without repeating yourself.

The content between the the `set` and `endset` tags is directly rendered using
the available context, and stored on the stack into a variable with the
provided name. Keep in mind that the variable is scoped, meaning that if you
set a variable while (for example) inside a for loop, the set variable will not
exist outside the scope of that for loop.

## Usage example

```stencil
// we start with 'x' and 'y' as empty variables

// set value
{% set x %}hello{% endset %} 
{% set y %}world{% endset %}
// x = "hello", y = "world"

// set inside for loop
{% for item in items %}
  {% set x %}item #{{item}}{% endset %}
  // x = "item #...", y = "world"
{% endfor %}

// after for loop
// x = "hello", y = "world"
```
