# Tag: "Import"

This tag loads and executes another template, but will **never** render any output. It's only purpose is for loading [macros](tag-macro.md) and [setting some variables](tag-set.md).

## Node Information

| Name      | Description            |
|-----------|------------------------|
| Tag Name  | `import`               |
| End Tag   | N/A                    |
| Rendering | Immediately; no output |

| Parameter  | Description                                | 
|------------|--------------------------------------------|
| Template   | The name of the template you want to load. |

The template name will depend on how your environment's loader is configured:

- If you're using a file loader, template should be a valid file name.
- If you're using a dictionary loader, template should be a key in that dictionary.

## When to use it

Should be used when you have some [macro](tag-macro.md)s or [set](tag-set.md)s that you want to reuse in multiple templates.

Note that this tag may appear similar to the existing [include](https://stencil.fuller.li/en/latest/builtins.html#include) tag, but the purposes are opposite of each other:

- `include` will render the included template, but never store changes to the context.
- `import` will never render the imported template, but will store changes to the context.

## Usage example

```stencil
{% import "common.stencil" %}

{% call test "a" "b" "c" %}
```

`common.stencil` file:

```stencil
{% macro test a b c %}
  Received parameters in test:
  - a = "{{a}}"
  - b = "{{b}}"
  - c = "{{c}}"
{% endmacro %}
```
