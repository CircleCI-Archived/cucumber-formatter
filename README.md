cucumber-formatter
==================

Custom formatter for Cucumber that defends against [timecop](https://github.com/travisjeffery/timecop) overriding Time.now.

Should be dumped into the features/support directory and specified with Cucumber's --format flag:

```
bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson
```

### How it works

Aliases Time.now to Time.original_now before any other files have a chance to modify the Time class. 
Then overrides the functions that keep track of the test's duration. 

This approach is somewhat brittle because it relies on the internals of before_step and after_step not changing.
