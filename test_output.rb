#!/usr/bin/env ruby

# takes two file names as arguments, expects first argument to be the unpatched
# json output and second argument to be the patched json output
# Checks that the times in the unpatched output are wrong and that the times in
# the patched output are correct.

require 'json'

broken_json = JSON.parse(File.read(ARGV[0]))
fixed_json = JSON.parse(File.read(ARGV[1]))

# durations are in nanoseconds
broken_duration =
  broken_json[0]['elements'][0]['steps'][0]['result']['duration']
fixed_duration =
  fixed_json[0]['elements'][0]['steps'][0]['result']['duration']

if broken_duration < 1 * 36_000 * 1E9
  throw "broken duration isn't long enough (#{broken_duration}), the test is " \
        'probably broken!'
end

if fixed_duration > 20 * 1E9 # give it a 10x margin (we sleep for 2 secs)
  throw 'fixed duration is too long, the patch is probably broken!'
end
