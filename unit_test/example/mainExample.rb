
require_relative 'objectExample.rb'

def mainExample()
  objectExample = ObjectExample.new()
  if objectExample.testOK() == 1
    return 1
  end
end

def mainExampleFAIL()
  objectExample = ObjectExample.new()
  if objectExample.testFAIL() == 1
    return 1
  end
end

mainExample()
mainExampleFAIL()
