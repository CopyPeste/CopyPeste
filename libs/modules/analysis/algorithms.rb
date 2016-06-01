require 'ffi'

class S_result < FFI::Struct 
  layout :line,  :int,
         :prcent_rst, :int 
end 

module Algorithms
  extend FFI::Library
  ffi_lib '../../../libs/modules/analysis/libs/algorithms.so'
  attach_function :levenshtein, [:string, :string], :int
  attach_function :fdupes_match, [:string, :int, :string, :int], :int
  attach_function :diff, [:string, :string], :double
  attach_function :fslice, [:string, :string, S_result], :int
end

result = S_result.new
result[:line] = -1
result[:prcent_rst] = -1

#block = File.open("./fslice/block_test2.txt", "rb")
#file = File.open("./fslice/file_test1.txt", "rb")

#check = Algorithms.fslice(block.read, file.read, result)

# if check == 0

#   puts "Line: " + result[:line].to_s
#   puts "Value: " + result[:prcent_rst].to_s + "%"
# else
#   puts "ret: " + check.to_s  
# end
# puts Algorithms.levenshtein("test", "test")
