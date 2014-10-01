cucumber-formatter
==================

[![Circle CI](https://circleci.com/gh/circleci/cucumber-formatter.png?style=badge&circle-token=4f4a358dfd39c63b90870dc70f7fffd005e4c85c)](https://circleci.com/gh/circleci/cucumber-formatter)

Custom formatter for Cucumber that defends against [timecop](https://github.com/travisjeffery/timecop) overriding Time.now.

The `_circleci_formatter.rb` file should be dumped into the features/support directory and specified with Cucumber's --format flag:

```
bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson
```

### How it works

Timecop redefines `Time.now` to `Time.now_without_mock_time`. If that method exists, then we call that method instead of `Time.now`.

This approach is somewhat brittle because it relies on the internals of before_step and after_step not changing.
