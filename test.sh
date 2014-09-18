#!/usr/bin/env bash

set -x
set -e

mkdir -p features/support
cp _circleci_formatter.rb features/support
mkdir -p gemfiles

# latest version is broken, see https://github.com/cucumber/cucumber/issues/745
#versions=( "1.3.17" "1.3.0" "git" )
versions=( "1.3.17" "1.3.0" )

for v in "${versions[@]}"
do
    echo "Testing with cucumber $v"
    GEMFILE="gemfiles/Gemfile.$v"

    if [[ "$v" -eq "git" ]]; then
        v="git: 'git@github.com:cucumber\/cucumber.git'"
    else
        v="'$v'"
    fi

    sed "s/gem 'cucumber'/gem 'cucumber', $v/" Gemfile > $GEMFILE

    export BUNDLE_GEMFILE=$GEMFILE

    bundle install

    rm broken.json; true # only delete if exists
    rm fixed.json; true

    # Run once with the unpatched formatter
    bundle exec cucumber --format json --out broken.json

    mkdir -p features/support
    cp _circleci_formatter.rb features/support

    # Run once with our formatter
    bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson --out fixed.json

    # Check that the times look correct
    ./test_output.rb broken.json fixed.json
done
