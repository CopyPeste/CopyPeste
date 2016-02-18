
# main_example.rb
#
# Sample example for unit test tools

require_relative 'object_example.rb'

# Method for test, this example works
def main_example()
  object_example = Object_example.new()
  if object_example.test_OK() == 1
    return 1
  end
end

# Method for test, this example does not work
def main_example_FAIL()
  object_example = Object_example.new()
  if object_example.test_FAIL() == 1
    return 1
  end
end

main_example()
main_example_FAIL()
