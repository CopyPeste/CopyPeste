
require_relative '../main_example.rb'

# First step to check if your code works
Given /^step ccb_main_example loading$/ do
  puts "Step ccb_main_example"

  if main_example() == 1
    # skip_this_scenario # Skip all
    pending("ccb_main_example task 1 FAIL")
  else
    puts "ccb_main_example task 1 OK"
  end
end

# Second step
When /^step ccb_main_example checking$/ do
end

# Third step
Then /^step ccb_main_example resulting$/ do
end
