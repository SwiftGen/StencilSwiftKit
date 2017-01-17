## Node Information

| Name      | Description                                                     |
|-----------|-----------------------------------------------------------------|
| Tag Name  | `macro`                                                         |
| End Tag   | `endmacro`                                                      |
| Rendering | None, content is stored unrendered in variable with block name  |
| Example   | `{% macro myBlock name %}Hello {{name}}{% endmacro %}`          |


| Parameter  | Description                               | 
|------------|-------------------------------------------|
| Block Name | The name of the block you want to define. |
| ...        | A variable list of parameters (optional). |

## When to use it

This node only works together with the `call` tag. The `macro` tag on itself
does nothing, it only stores it's unrendered contents in a variable on the
stack.

The parameters in the defenition will be available as variables in the context
during invocation. Do note that a `macro` block's execution is scoped, thus any
changes to the context inside of it will not be avaible once execution leaves
the block's scope.

See the documentation for the [call tag](tag-call.md).
