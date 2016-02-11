
require_relative '../mainExample.rb'

# First step to check if your code works
Given /^step ccbMainExampleFAIL loading$/ do
  puts "Step ccbMainExampleFAIL"
  if mainExampleFAIL() == 1
    # skip_this_scenario # Skip all
    pending("ccbMainExampleFAIL task 1 FAIL")
  else
    puts "ccbMainExampleFAIL task 1 OK"
  end
end

# Second step
When /^step ccbMainExampleFAIL checking$/ do
end

# Third step
Then /^step ccbMainExampleFAIL resulting$/ do
end
