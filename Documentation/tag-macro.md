# Tag: "Macro"

This tag stores an entire content tree into a variable to be evaluated and rendered later (possibly multiple times).

This can be thought like defining a function or macro.

## Node Information

| Name      | Description                                                     |
|-----------|-----------------------------------------------------------------|
| Tag Name  | `macro`                                                         |
| End Tag   | `endmacro`                                                      |
| Rendering | None; content is stored unrendered in variable with block name  |
| Example   | `{% macro myBlock name %}Hello {{name}}{% endmacro %}`          |


| Parameter  | Description                               | 
|------------|-------------------------------------------|
| Block Name | The name of the block you want to define. |
| ...        | A variable list of parameters (optional). |

## When to use it

This node only works together with the `call` tag. The `macro` tag on itself renders nothing as its output, it only stores it's unrendered template contents in a variable on the stack to be called later.

The parameters in the definition will be available as variables in the context during invocation. Do note that a `macro` block's execution is scoped, thus any changes to the context inside of it will not be available once execution leaves the block's scope.

## Usage example

```stencil
{% macro hi name %}
Hello, {{name}}! How are you?
{% endmacro %}

{% call hi Alice %}
{% call hi Bob %}
```

```text
Hello, Alice! How are you?
Hello, Bob! How are you?
```

See the documentation for the [call tag](tag-call.md) for a full and more complex usage example.
