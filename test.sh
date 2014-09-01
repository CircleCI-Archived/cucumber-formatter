#!/usr/bin/env bash

set -x
set -e

# Run once with the unpatched formatter
bundle exec cucumber --format json --out broken.json

mkdir -p features/support
cp _circleci_formatter.rb features/support

# Run once with our formatter
bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson --out fixed.json

# Check that the times look correct
./test_output.rb broken.json fixed.json
