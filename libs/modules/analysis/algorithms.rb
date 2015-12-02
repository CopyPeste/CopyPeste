require 'ffi'

module Algorithms
  extend FFI::Library
  ffi_lib './libs/algorithms.so'
  attach_function :levenshtein, [:string, :string], :int
  attach_function :compare_files_match, [:string, :string, :int], :int
end

puts "Levenshtein distance of #{ARGV[0]} and #{ARGV[1]} = #{Algorithms.levenshtein(ARGV[0], ARGV[1])}"

rep = "Rsync compare file of #{ARGV[0]} and #{ARGV[1]} = " 

if (Algorithms.compare_files_match(ARGV[0], ARGV[1], 512) == 0) then
  rep += "SIMILARE"
else
  rep += "DIFFERENT"
end

puts rep
