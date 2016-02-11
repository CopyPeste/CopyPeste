
# mainExample.rb
#
# Sample example for unit test tools

require_relative 'objectExample.rb'

# Method for test, this example works
def mainExample()
  objectExample = ObjectExample.new()
  if objectExample.testOK() == 1
    return 1
  end
end

# Method for test, this example does not work
def mainExampleFAIL()
  objectExample = ObjectExample.new()
  if objectExample.testFAIL() == 1
    return 1
  end
end

mainExample()
mainExampleFAIL()
