# multipattern

a simple extension to any [`pattern_time`](https://monome.org/docs/norns/reference/lib/pattern_time) instance. add multiple process functions to a single pattern or multiple process functions to multiple patterns.

| syntax                                                         | description |
| ---                                                            | ---         |
| `mpat = multipattern.new(pattern)`                             | create a new multipattern instance from a `pattern_time` instance. |
| `wrapped_function = mpat:wrap(id, some_function)`              | wrap a function. calls to `wrapped_function` will pass through to `some_function`, but will also be watched by the `pattern_time` instance. the playing pattern will call `some_function` with arguments from the past. the `id` must be a unique value for each function. |
| `wrapped_function = multipattern.wrap(set, id, some_function)` | wrap a function in a table of multiple `multipattern` instances. |
