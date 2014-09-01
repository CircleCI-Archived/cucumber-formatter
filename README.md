cucumber-formatter
==================

[![Circle CI](https://circleci.com/gh/circleci/cucumber-formatter.png?style=badge&circle-token=4f4a358dfd39c63b90870dc70f7fffd005e4c85c)](https://circleci.com/gh/circleci/cucumber-formatter)

Custom formatter for Cucumber that defends against [timecop](https://github.com/travisjeffery/timecop) overriding Time.now.

Should be dumped into the features/support directory and specified with Cucumber's --format flag:

```
bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson
```

### How it works

Aliases Time.now to Time.original_now before any other files have a chance to modify the Time class. 
Then overrides the functions that keep track of the test's duration. 

This approach is somewhat brittle because it relies on the internals of before_step and after_step not changing.
