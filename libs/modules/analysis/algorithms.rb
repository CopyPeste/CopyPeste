require 'ffi'

module Algorithms
  extend FFI::Library
  ffi_lib '../../../libs/modules/analysis/libs/algorithms.so'
  attach_function :levenshtein, [:string, :string], :int
  attach_function :compare_files_match, [:string, :string, :int], :int
end
