## Node Information

| Name      | Description                                                  |
|-----------|--------------------------------------------------------------|
| Tag Name  | `call`                                                       |
| End Tag   | N/A                                                          |
| Rendering | Directly, output is the rendering of the called macro block  |
| Example   | `{% call myBlock "Dave" %}`                                  |


| Parameter  | Description                                               | 
|------------|-----------------------------------------------------------|
| Block Name | The name of the block you want to invoke.                 |
| ...        | A variable list of arguments, must match block definition |

## When to use it

This node only works together with the `macro` tag. You must define a macro
block before you can call it.

In contrast to the `set` tag, the `call` and `macro` tags can be used for
delayed execution of blocks. When the renderer encounters a `macro` block, it
won't be rendered, but it's contents stored as a body of the block. When the
renderer encounters a `call` tag, it will look up any matching block (by name),
and will then invoke it using the context from the invocation point.

The number of arguments in a `call` invocation must match the number of
parameters in a `macro` definition.

Do note that, due to the delayed invocation, a `macro` block can contain `call`
tags that invoke the `macro` block again, thus allowing for scenarios such as
recursion.

See the documentation for the [macro tag](tag-macro.md).

## Usage example

```stencil
{# define test1 #}
{% macro test1 %}
  Hello world! (inside test)
{% endmacro %}

{# define test2 #}
{% macro test2 a b c %}
  Received parameters in test2:
  - a = "{{a}}"
  - b = "{{b}}"
  - c = "{{c}}"

  // calling test1
  {% call test1 %}
{% endmacro %}

{# calling test2 #}
{% call test2 "hey" 123 "world" %}
```

Will output:

```text
  Received parameters in test2:
  - a = "hey"
  - b = "123"
  - c = "world"

  // calling test1
  Hello world! (inside test)
```
