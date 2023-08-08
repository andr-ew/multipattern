# multipattern

a simple extension to any [`pattern_time`](https://monome.org/docs/norns/reference/lib/pattern_time) instance. add multiple process functions to a single pattern or multiple process functions to multiple patterns.

| syntax                                                         | description |
| ---                                                            | ---         |
| `mpat = multipattern.new(pattern)`                             | create a new multipattern instance from a `pattern_time` instance. |
| `mpat:add_process(id, func)`                                   | add a new process function with a unique id                        |
| `mpat:watch(id, e)`                                            | watch the event `e`. recorded data will be passed to the process at the id |
| `wrapped_function = mpat:wrap(id, some_function)`              | wrap a function with a unique id - this is a shortcut for `add_process` + `watch`. calls to `wrapped_function` will pass through to `some_function`, but will also be watched by the `pattern_time` instance. the playing pattern will call `some_function` with arguments from the past. the `id` must be a unique value for each function. |
| `multipattern.add_process(set, id, process)`                   | add a new process to all `multipattern` instaces in the table `set` |
| `multipattern.watch(set, id, e)`                               | watch the event at all `multipattern` instaces in the table `set` |
| `wrapped_function = multipattern.wrap(set, id, some_function)` | wrap a function in all `multipattern` instaces in the table `set` |
