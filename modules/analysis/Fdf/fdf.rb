# -*- coding: utf-8 -*-

# FDF V1.1

require 'json'
require './UseLevenshtein'
require './UseRsync'
require '../../../libs/modules/analysis/algorithms'
require '../../../libs/modules/analysis/SortFile'
require '../../../libs/database/DbHdlr'

# Call levenshtein class
#
# @param [Hash] hash of file who will be analyse
def call_levenshtein()
  lev.start()
  lev.get_result_matched()
end


# Call the Rsync class
#
# @param []
def call_rsync(result)
  rsync = UseRsync.new(result)
  rsync.start()
end


#
#        Idée de rangement des donnée
#
#        ex : tab[0]-> hash[% de ressemblance] -> tab[0] -> [file1, file2, distance?]
#             tab[0]-> hash[extension] -> hash[% de ressemblance] -> tab[0] -> [file1, file2, , distance?]
#           
#             tab -> [file1, file2]
#             %de ressemblance (distance +rsync ?)
#             _id document
def put_result_in_database(mongo, lev)
  lev.get_global_result()
  #mongo.ins_data("Fdf", )
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
  lev = UseLevenshtein.new(file_hash)
  result = call_levenshtein()
  call_rsync(result)
  put_lev_result_in_database()
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
  list
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
  sort_tab(documents)
end


# function use to init the list of file for fdf
#
# @parma [Object] DbHdlr, will be removed when test will be finished 
def init_fdf(mongo)
  list = get_doc_to_analyse(mongo, nil)
  fdf(list, mongo)
end


mongo = DbHdlr.new()
init_fdf(mongo)
