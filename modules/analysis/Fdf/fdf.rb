# -*- coding: utf-8 -*-

# FDF V1.1

require 'json'
require './UseLevenshtein'
require './UseRsync'
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


# Start Rsync and get the result of the analyses
#
# @param [Array] Array containing files witch matched
# @param [Array] Array containing the result of the levenshtein for each files who matched
# Return an Array of Hash. one Hash is a result of two file analyses
def call_rsync(rsync_tab, lev_result)
  rsync = UseRsync.new(rsync_tab, lev_result)
  rsync.start()
  rsync.get_result_data()
end


def put_result_in_database(mongo, data)
  mongo.ins_data("Duplicate", data, true)
end


# Main function of the fdf, call the sort class and the levenshtein/resync methode
#
# @param [Array] list of all the file who will be analyse
# @param [Array]/[nil] Array of all the size for each file or nil. nil is the value by default
def fdf(list, mongo, octe = nil)
  file_hash = {}
  fichier = SortFile.new(list, octe)
  fichier.start()
  file_hash = fichier.get_hash()
  lev = UseLevenshtein.new(file_hash)
  rsync_tab = call_levenshtein(lev)
  lev_result = lev.get_levenshtein_result()
  final_data = call_rsync(rsync_tab, lev_result)
  put_result_in_database(mongo, final_data)
  puts "\n\n ===========Duplicates==========\n\n"
  mongo.debug("Duplicate")
end


# Extraxt the path and name for each files and concat them. 
#
# @param [Array][Array][Hash] take an Array of Array of hash. [files by extension][one file][hash of the file]
# Return a Array of files with the complete file path :  Array[0] = /home/test/expemple.c
def sort_tab(documents)
  list = []
  documents.each do |data|
    data.each do |file|
      list << file["path"] + "/" + file["name"]
    end
  end
  list
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
#
# @parma [Object] DbHdlr, mongo object
def init_fdf(mongo)
  list = get_doc_to_analyse(mongo, nil)
  fdf(list, mongo)
end


mongo = DbHdlr.new()
init_fdf(mongo)
