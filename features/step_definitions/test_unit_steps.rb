require 'timecop'
# Scale time by a large margin
Timecop.scale(36_000)

Then(/^I can assert that (\d+) == (\d+)$/) do |var_a, var_b|
  # sleep 2 seconds so that we can compare times
  sleep(2)
  assert_equal(var_a, var_b)
end
