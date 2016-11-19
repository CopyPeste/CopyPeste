# Module containing all available algorithms in analysis modules.
#
# Available algorithms are:
# * Levenshtein distance - Algorithms.levenshtein - Compute the distance between two strings.
# * Fdupes - Algorithms.fdupes_match - Check whether two files are identical.
# * Diff - Algorithms.diff - Compute the percentage of similarity between two files.

require 'ffi'

module Algorithms
  extend FFI::Library
  ffi_lib File.join CopyPeste::Require::Path.algorithms, 'algorithms.so'
  attach_function :levenshtein, [:string, :string], :int
  attach_function :fdupes_match, [:string, :int, :string, :int], :int
  attach_function :diff, [:string, :string], :double
end
