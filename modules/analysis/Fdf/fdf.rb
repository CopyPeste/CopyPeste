# -*- coding: utf-8 -*-

# FDF V1.1

require 'json'
require './UseLevenshtein'
require './CheckMatch'
require '../../../libs/modules/analysis/algorithms'
require '../../../libs/modules/analysis/SortFile'
require '../../../libs/database/DbHdlr'

# Start levenshtein and get the result of the analyses
#
# @param [Hash] hash of file who will be analyse
# Return a Array containning files that matched
def call_levenshtein(lev)
  lev.start()
  lev.get_result_matched()
end


def put_result_in_database(mongo, data)
  mongo.ins_data("Duplicate", data, true)
end


def sort_files_with_rules(rules, list, size)
  fichier = SortFile.new()
  i = 0
  list.each do |file|
    extension = fichier.get_extension(file)
    case rules
    when nil
      fichier.sort_no_rulls(file)
    when "-s"
      fichier.sort_by_size(file, size[i])
    when "-e"
      fichier.sort_by_extension(file, extension)
    when "-e-s", "-es", "-se"
      fichier.sort_by_extension_and_size(file, extension, size[i])
    end
    i += 1
  end
  fichier.get_hash()
end

# Main function of the fdf, call the sort class and the levenshtein/resync methode
#
# @param [Array] list of all the file who will be analyse
# @param [Array]/[nil] Array of all the size for each file or nil. nil is the value by default
def fdf(list, mongo, rules = nil, size = nil)
  file_hash = {}
  file_hash = sort_files_with_rules(rules, list, size)
  
  puts file_hash
  #  lev = UseLevenshtein.new(file_hash)
  #  fdup_tab = call_levenshtein(lev)
  #  lev_result = lev.get_levenshtein_result()
  
  #  final_data = check_files_similarity(fdup_tab, lev_result)
  
  #put_result_in_database(mongo, final_data)
  #puts "\n\n ===========Duplicates==========\n\n"
  #mongo.debug("Duplicate")
end


# Extraxt the path and name for each files and concat them. 
#
# @param [Array][Array][Hash] take an Array of Array of hash. [files by extension][one file][hash of the file]
# Return a Array of files with the complete file path :  Array[0] = /home/test/expemple.c
def sort_tab(documents)
  files = []
  list = []
  size = []
  documents.each do |data|
    data.each do |file|
      list << file["path"] + "/" + file["name"]
      size << file["size"]
    end
  end
  files << list << size
end


# Get files from the database that will be analyses
#
# @param [Object] DbHdlr, mongo object
# @param [String] Extension of file to analyses. Nil by default (take all th file from the database).
# Return a Array of files with the complete file path :  Array[0] = /home/test/expemple.c
def get_doc_to_analyse(mongo, ext = nil)
  query = {}
  documents = []
  query["name"] = ext
  ext == nil ? query = nil : query
  result = mongo.get_data("Extension", query, nil)
  result.each do |data|
    data = JSON.parse(data.to_json)
    data["_id"] = BSON::ObjectId.from_string(data['_id']['$oid'])
    documents << mongo.get_document("Fichier", "ext", data["_id"])
  end
  sort_tab(documents)
end


# Function use to initialize and get the list of file witch will be analyses.
# If you want to analyses only files witch has same sizes, fdf(files[0], mongo, rules, files[1])
# files[0] contain all files and file[1] containe all size of files
#
# @parma [Object] DbHdlr, mongo object
def init_fdf(mongo, rules)
  files = get_doc_to_analyse(mongo, nil)
  fdf(files[0], mongo, rules, files[1])
end


# For test with rules : 
# nil no sort.
# -e sort by extension.
# -s sort by size.
# -se|-es|-e -s| sort by extention and size. 
rules = nil
if ARGV.size >= 1
  rules = ""
  ARGV.each do |r|
    rules = rules + r
  end
end
mongo = DbHdlr.new()
init_fdf(mongo, rules)
