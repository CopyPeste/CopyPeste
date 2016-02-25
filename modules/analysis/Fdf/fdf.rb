
# FDF V1.1

require './UseLevenshtein'
require './UseRsync'
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

def sort_tab(tab)
  list = []
  tab.each do |data|
    data.each do |document|
      list << document["path"] + "/" + document["name"]
    end
  end
  puts "=========LIST=========== \n\n"
  puts list
  return list
end

def get_doc_to_analyse(mongo, ext = nil)
  query = {}
  tab = []
  query["name"] = ext
  if ext == nil
    query = nil
  end
  result = mongo.get_data("Extension", query, nil)
  result.each do |data|
    data = JSON.parse(data.to_json)
    data["_id"] = BSON::ObjectId.from_string(data['_id']['$oid'])
    documents = mongo.get_document("Fichier", "ext", data["_id"])
    tab << documents
  end
  return sort_tab(tab)
end

def init_fdf(mongo)
  list = get_doc_to_analyse(mongo, nil)     # place com if need to test without BDD  else remove it
  #scan = ScanSystem.new(ARGV[0]) # remove com if need to test without the BDD
  #list = get_file_from_scan(scan) # remove com if need to test without the BDD
  fdf(list, nil)
end

# init_fdf() # remove com if need to test without the BDD
