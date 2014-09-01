require 'timecop'
Timecop.scale(36000)

Then /^I can assert that (\d+) == (\d+)$/ do |var_a, var_b|
  sleep(1)
  assert_equal(var_a, var_b)
end
