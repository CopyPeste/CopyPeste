
# FDF V1.1

require 'json'
require './UseLevenshtein'
require './UseRsync'
require_relative '../../../libs/modules/analysis/algorithms'
require '../../../libs/modules/analysis/SortFile'
require '../../../libs/BDD/DbHdlr'

# Not important will be remove soon
module Algorithms
  extend FFI::Library
  ffi_lib '../../../libs/modules/analysis/libs/algorithms.so'
  attach_function :levenshtein, [:string, :string], :int
  attach_function :compare_files_match, [:string, :string, :int], :int
end


# Call levenshtein class
#
# @param [Hash] hash of file who will be analyse
def call_levenshtein(file_hash)  
  lev = UseLevenshtein.new(file_hash)
  lev.start()
  return lev.get_result()
end


# Call the Rsync class
#
# @param []
def call_rsync(result)
  rsync = UseRsync.new(result)
  rsync.start()
end


# Main function of the fdf, call the sort class and the levenshtein/resync methode
#
# @param [Array] list of all the file who will be analyse
# @param [Array]/[nil] list of all the size of each file to be sort by extension and size or nil. nil by default
def fdf(list, octe = nil)
  file_hash = {}
  fichier = SortFile.new(list, octe)
  fichier.start()
  file_hash = fichier.get_hash()
  result = call_levenshtein(file_hash)
  call_rsync(result)
end


# Function use for test when the bdd is not use
#
# @param [Object] ScanSystem object.
def get_file_from_scan(scan)
  scan.init()
  return scan.get_tab_file
end


# Extraxt the path and name of files and put return a Array of the complete file with path (/home/test/expemple.c)
#
# @param [Array][Array][Hash] take an Array of Array of hash. [files by extension][one file][hash of the file]
def sort_tab(documents)
  list = []
  documents.each do |data|
    data.each do |file|
      list << file["path"] + "/" + file["name"]
    end
  end
  return list
end


# Get the files from the databases witch will be analyses
#
# @param [Object] DbHdlr, mongo object
# @param [String] extension of file to analyse. Nil by default (take all th file from the databases). 
def get_doc_to_analyse(mongo, ext = nil)
  query = {}
  documents = []
  query["name"] = ext
  if ext == nil
    query = nil
  end
  result = mongo.get_data("Extension", query, nil)
  result.each do |data|
    data = JSON.parse(data.to_json)
    data["_id"] = BSON::ObjectId.from_string(data['_id']['$oid'])
    documents << mongo.get_document("Fichier", "ext", data["_id"])
  end
  return sort_tab(documents)
end


# function use to init the list of file for fdf
#
# @parma [Object] DbHdlr, will be removed when test will be finished 
def init_fdf(mongo)
  list = get_doc_to_analyse(mongo, nil)     # place com if need to test without BDD  else remove it
  #scan = ScanSystem.new(ARGV[0])           # remove com if need to test without the BDD
  #list = get_file_from_scan(scan)          # remove com if need to test without the BDD
  fdf(list)
end

mongo = DbHdlr.new()
init_fdf(mongo) # remove com if need to test without the BDD
