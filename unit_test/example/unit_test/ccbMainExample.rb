
require_relative '../mainExample.rb'

# First step to check if your code works
Given /^step ccbMainExample loading$/ do
  puts "Step ccbMainExample"

  if mainExample() == 1
    # skip_this_scenario # Skip all
    pending("ccbMainExample task 1 FAIL")
  else
    puts "ccbMainExample task 1 OK"
  end
end

# Second step
When /^step ccbMainExample checking$/ do
end

# Third step
Then /^step ccbMainExample resulting$/ do
end
