
# FDF V1.1

require './SortFile'
require './UseLevenshtein'
require './UseRsync'
require 'ffi'

module Algorithms
  extend FFI::Library
  ffi_lib '../libs/algorithms.so' #chemin vers la lib
  attach_function :levenshtein, [:string, :string], :int
  attach_function :compare_files_match, [:string, :string, :int], :int

end

def callLevenshtein(fileHash)  
  lev = UseLevenshtein.new(fileHash)
  lev.start()
  return lev.getResult()
end

def callRsync(result)
  rsync = UseRsync.new(result)
  rsync.start()
end

def fdf(list, octe)
  fileHash = Hash.new
  
  fichier = SortFile.new(list, nil) #nil ou octe pour le moment
  fichier.start()
  fileHash = fichier.getHash()
  result = callLevenshtein(fileHash)
  callRsync(result)
end

list = ["path1/fichier1.c", "path2/fichier16.cpp", "path3/fichier3.java", "path4/fichier4.txt", "path5/fichier5.rb", "path6/fichier6.php", "path7/fichier7.xml", "path8/fichier1.c", "path9/fichier16.cpp", "path10/fichier10.java", "path11/fichier11.java", "path12/fichier12.rb", "path13/fichier13.php", "path14/fichier14.xml", "path15/fichier15.c", "path16/fichier168945.cpp", "/home/edouard/Documents/EIP/Ruby/algorithm/test.c", "/home/edouard/Documents/EIP/Ruby/algorithm/Test/test.c", "/home/edouard/Documents/EIP/Ruby/algorithm/Test/test2.cpp", "/home/edouard/Documents/EIP/Ruby/algorithm/test2.cpp", "toto", "toto"]

octe =["500", "2542", "500", "98745", "584", "65452", "6451215", "500", "2542", "507", "507", "8790", "575", "744", "565489", "2542", "57", "57", "38", "38", "2", "2"]

fdf(list, octe)
