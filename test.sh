#!/usr/bin/env bash

set -x
set -e

bundle exec cucumber --format json --out broken.json

mkdir -p features/support
cp _circleci_formatter.rb features/support

bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson --out fixed.json

./test_output.rb broken.json fixed.json
