#!/usr/bin/env bash

set -x

FAILURE=false

mkdir -p gemfiles
mkdir $CIRCLE_ARTIFACTS/broken
mkdir $CIRCLE_ARTIFACTS/fixed

versions=( "2.3.2" "2.2.0" "2.1.0" "1.3.20" )

for v in "${versions[@]}"
do
    echo "Testing with cucumber $v"
    GEMFILE="gemfiles/Gemfile.$v"

    quoted_v="'$v'"

    sed "s/gem 'cucumber'/gem 'cucumber', $quoted_v/" Gemfile > $GEMFILE

    export BUNDLE_GEMFILE=$GEMFILE

    bundle install

    rm broken.json || true # only delete if exists
    rm fixed.json || true

    # Run once with the unpatched formatter
    bundle exec cucumber --format json --out broken.json
    cp broken.json $CIRCLE_ARTIFACTS/broken/broken-$v.json

    mkdir -p features/support
    cp _circleci_formatter.rb features/support

    # Run once with our formatter
    bundle exec cucumber --format CircleCICucumberFormatter::CircleCIJson --out fixed.json
    cp fixed.json $CIRCLE_ARTIFACTS/fixed/fixed-$v.json

    # Check that the times look correct
    ./test_output.rb broken.json fixed.json || FAILURE=true

    rm features/support/_circleci_formatter*
done

if [[ $FAILURE == true ]] ; then exit 1; else exit 0; fi
