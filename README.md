# multipattern

a simple extension to any [`pattern_time`](https://monome.org/docs/norns/reference/lib/pattern_time) instance that allows it to track multiple interface elements via wrapped functions.

| syntax                                                         | description |
| ---                                                            | ---         |
| `mpat = multipattern.new(pattern)`                             | create a new multipattern instance from a `pattern_time` instance. |
| `wrapped_function = mpat:wrap(id, some_function)`              | wrap a function. calls to `wrapped_function` will pass through to `some_function`, but will also be watched by the `pattern_time` instance. the playing pattern will call `some_function` with arguments from the past. the `id` must be a unique value for each function |
| `set_param = mpat:wrap_paramset(paramset)`                     | wrap the paramset. `set_param` is a table of functions. calls to `set_param[id](value)` will set the value of a param, and the value will be watched by the `pattern_time` instance. |
| `wrapped_function = multipattern.wrap(set, id, some_function)` | wrap a function in a table of multiple `multipattern` instances. |
| `set_param = multipattern.wrap_paramset(set, paramset)`        | wrap the paramset in a table of multiple `multipattern` instances. |
