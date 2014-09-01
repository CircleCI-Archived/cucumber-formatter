require 'timecop'
Timecop.scale(36000)

Then /^I can assert that (\w+) == (\w+)$/ do |var_a, var_b|
  sleep(1)
  assert_equal(a, b)
end
