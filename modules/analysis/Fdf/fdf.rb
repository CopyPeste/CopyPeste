
# FDF V1.1

require './SortFile'
require './UseLevenshtein'
require './UseRsync'
require './ScanSystem'
require 'ffi'

module Algorithms
  extend FFI::Library
  ffi_lib '../../../libs/modules/analysis/libs/algorithms.so' #chemin vers la lib
  attach_function :levenshtein, [:string, :string], :int
  attach_function :compare_files_match, [:string, :string, :int], :int

end

def call_levenshtein(file_hash)  
  lev = UseLevenshtein.new(file_hash)
  lev.start()
  return lev.get_result()
end

def call_rsync(result)
  rsync = UseRsync.new(result)
  rsync.start()
end

def fdf(list, octe)
  file_hash = {}
  fichier = SortFile.new(list, nil) #nil ou octe pour le moment
  fichier.start()
  file_hash = fichier.get_hash()
  result = call_levenshtein(file_hash)
  call_rsync(result)
end

def get_file_from_scan(scan)
  scan.init()
  return scan.get_tab_file
end

scan = ScanSystem.new(ARGV[0])
list = get_file_from_scan(scan)
fdf(list, nil)
