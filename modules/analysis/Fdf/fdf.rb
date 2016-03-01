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
  lev.get_file_matched()
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

def delete_in_extension_collection(mongo, file_id, query_ext)
  tmp = 0
  i = 0
  result = mongo.get_data("Extension", query_ext)[0]
  result["files_id"].each do |id|
    if id["$oid"] == file_id
      tmp = i
    end
    (result["files_id"])[i] = JSON.parse(id.to_json)
    (result["files_id"])[i] = BSON::ObjectId.from_string(id["$oid"])
    i += 1
  end
  result["_id"] = JSON.parse(result["_id"].to_json)
  result["_id"] = BSON::ObjectId.from_string(result["_id"]["$oid"])
  mongo.rm_data(result, "Extension")
  (result["files_id"]).delete_at(tmp)
  if (result["files_id"]).empty?() 
    puts "\nExtesion #{result["name"]} deleted no more files" 
  else
    mongo.ins_data("Extension", result)
  end
end


def delete_file_in_db(path, name, mongo)
  query_ext = {}
  result = mongo.get_data("Fichier", {:name => name, :path => path})[0]
  result = JSON.parse(result.to_json)
  query_ext["_id"] = BSON::ObjectId.from_string(result["ext"]["$oid"])
  file_id = result["_id"]["$oid"]
  mongo.rm_data({:name => name, :path => path}, "Fichier")
  delete_in_extension_collection(mongo, file_id, query_ext)
  mongo.debug("Fichier")
  mongo.debug("Extension")
  return false
end


def check_file_existe(path, name, mongo)
  if File.file?(path + "/" + name)
    true
  else
    delete_file_in_db(path, name, mongo)
  end
end


# Extraxt the path and name for each files and concat them. 
#
# @param [Array][Array][Hash] take an Array of Array of hash. [files by extension][one file][hash of the file]
# Return a Array of files with the complete file path :  Array[0] = /home/test/expemple.c
def sort_tab(documents, mongo)
  files = []
  list = []
  size = []
  documents.each do |data|
    data.each do |file|
      if check_file_existe(file["path"], file["name"], mongo) == true
        list << file["path"] + "/" + file["name"]
        size << file["size"]
      end
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
    data["_id"] = BSON::ObjectId.from_string(data["_id"]["$oid"])
    documents << mongo.get_document("Fichier", "ext", data["_id"])
  end
  sort_tab(documents, mongo)
end



# Main function of the fdf, call the sort class and the levenshtein/resync methode
#
# @param [Array] list of all the file who will be analyse
# @param [Array]/[nil] Array of all the size for each file or nil. nil is the value by default
def fdf(list, mongo, rules = nil, size = nil)
  file_hash = {}
  file_hash = sort_files_with_rules(rules, list, size)
  lev = UseLevenshtein.new(file_hash)
  fdup_tab = call_levenshtein(lev)
  lev_result = lev.get_levenshtein_result()
  if fdup_tab == nil
    puts "No files to analyses"
    return nil
  end
  puts fdup_tab
  puts lev_result
  final_data = check_files_similarity(fdup_tab, lev_result)

  #put_result_in_database(mongo, final_data)
  #puts "\n\n ===========Duplicates==========\n\n"
  #mongo.debug("Duplicate")
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
