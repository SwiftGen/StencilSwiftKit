# Tag: "Map"

This tag iterates over an array, transforming each element, and storing the resulting array into a variable for later use.

## Node Information

| Name      | Description                                                     |
|-----------|-----------------------------------------------------------------|
| Tag Name  | `map`                                                           |
| End Tag   | `endmap`                                                        |
| Rendering | Immediately; no output                                          |
| Example   | `{% map myArray into myNewArray using myItem %}...{% endmap %}` |


| Parameter   | Description                                                        |
|-------------|--------------------------------------------------------------------|
| Array Name  | The name of the array you want to transform.                       |
| Result Name | The name of the variable you want to store into.                   |
| Item Name   | Optional; name of the variable for accessing the iteration's value |

## When to use it

Handy when you have an array of items, but want to trasform them before applying other operations on the whole collection. For example, you can easily use this node to map an array of strings so that they're all uppercase and preprended with their index number in the collection. You can then join the resulting array into a string using the `join` filter.

You must at least provide the name of the variable you're going to transform, and the name of the variable to store into. The block between the map/endmap tags will be executed once for each array item. Optionally you can provide a name for the variable of the iteration's element, that will be available during the block's execution. If you don't provide an item name, you can always access it using the `maploop` context variable.

The `maploop` context variable is available during each iteration, similar to the `forloop` variable when using the `for` node. It contains the following properties:
- `counter`: the current iteration of the loop.
- `first`: true if this is the first time through the loop.
- `last`: true if this is the last time through the loop.
- `item`: the array item for this iteration.

Keep in mind that, similar to the [set tag](tag-set.md), the result variable is scoped, meaning that if you set a variable while (for example) inside a `macro` call, the set variable will not exist outside the scope of that call.

## Usage example

```stencil
// we start with 'list' with as value ['a', 'b', 'c']

// map the list without item name
{% map list into result1 %}{{maploop.item|uppercase}}{% endmap %} 
// result1 = ['A', 'B', 'C']

// map with item name
{% map list into result2 using item %}{{item}}{{item|uppercase}}{% endmap %} 
// result2 = ['aA', 'bB', 'cC']

// map using the counter variable
{% map list into result3 using item %}{{maploop.counter}} - {{item}}{% endmap %} 
// result3 = ['0 - a', '1 - b', '2 - c']
```
