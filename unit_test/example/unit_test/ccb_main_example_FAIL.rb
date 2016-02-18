
require_relative '../main_example.rb'

# First step to check if your code works
Given /^step ccb_main_example_FAIL loading$/ do
  puts "Step ccb_main_example_FAIL"
  if main_example_FAIL() == 1
    # skip_this_scenario # Skip all
    pending("ccb_main_example_FAIL task 1 FAIL")
  else
    puts "ccb_main_example_FAIL task 1 OK"
  end
end

# Second step
When /^step ccb_main_example_FAIL checking$/ do
end

# Third step
Then /^step ccb_main_example_FAIL resulting$/ do
end
