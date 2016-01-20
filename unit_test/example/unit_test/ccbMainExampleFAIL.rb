
require_relative '../mainExample.rb'
#
Given /^step ccbMainExampleFAIL loading$/ do
  puts "Step ccbMainExampleFAIL"
  if mainExampleFAIL() == 1
    # skip_this_scenario # Skip all
    pending("ccbMainExampleFAIL task 1 FAIL")
  else
    puts "ccbMainExampleFAIL task 1 OK"
  end
end

#
When /^step ccbMainExampleFAIL checking$/ do
end

#
Then /^step ccbMainExampleFAIL resulting$/ do
end
