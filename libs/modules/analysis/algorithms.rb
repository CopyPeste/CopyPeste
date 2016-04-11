require 'ffi'

module Algorithms
  extend FFI::Library
  ffi_lib '../../../libs/modules/analysis/libs/algorithms.so'
  attach_function :levenshtein, [:string, :string], :int
  attach_function :fdupes_match, [:string, :int, :string, :int], :int
  attach_function :levenshtein_distance, [:string, :string], :int
  attach_function :diff, [:string, :string], :int
end
