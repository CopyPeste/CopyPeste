require_relative './scan_system'
require_relative '../../libs/modules/analysis/sort_file'
require_relative '../../libs/database/DbHdlr'
require 'mongo'
require 'json'
require 'filemagic'


# Add document into the database
#
# @param [Object] DbHdlr object
# @param [String] name of the collection to use
# @param [JSON] a json Array (tab[0] => json_document, tab[1] => json_document).
#               Or a simple json file
# @param [Bool] true = multiple insertion in databse (if you have a json tab).
#               false = simple insertion (if you have a simple json file)
def fill_db(mongo, collection, json_tab, multifile)
  mongo.ins_data(collection, json_tab, multifile)
end


# Creat a json document from a string (use when you get a document from the database)
# Function used to create a document for the Extension collection
#
# @param [String] document from the database in string form
# @Return [JSON] that correspond to one document in the Extension collection
def set_extension_json(document)
  tab = []
  json_document = JSON.parse(document.to_json)
  json_document["_id"] = BSON::ObjectId.from_string(document['_id']['$oid'])
  (json_document["files_id"]).each do |data|
    data = BSON::ObjectId.from_string(data["$oid"])
    tab << data
  end
  json_document["files_id"] = tab
  json_document
end


# Create the document for the Extension collection
#
# @param [Object] DbHdlr object (mongo object)
# @param [Hash] a hash about a file that corresponds to one type of extension
# @param [String] the extension ("c", "cpp", etc)
def set_collection_extension(mongo, file, key)
  file_tab = mongo.get_data("Fichier", {:ext => file["ext"]})
  document = {}
  tab_id = []
  json_tab = []
  file_tab.each do |data|
    tab_id << data["_id"]
  end
  document["_id"] = file_tab[0]["ext"]
  document["name"] = key
  document["files_id"] = tab_id
  json_tab << set_extension_json(document)
  fill_db(mongo, "Extension", json_tab, true)
end


# Insert all documents scaned into the database,
#
# @parma [Hash] a hash containing files sorted by extension
# @parma [Object] a DbHdlr object (mongo object)
# @parma [Object] a ScanSystem object
def sort_insert_db(file_hash, mongo, scan)
  file_hash.each do |key, value|
    json_tab = []
    ext_id = BSON::ObjectId.from_time(Time.now, unique: true)
    value.each do |file|
      if (result = scan.set_info_file(ext_id, file)) != nil
        json_document = result
        json_document = JSON.parse(json_document)
        json_document["ext"] = BSON::ObjectId.from_string(json_document["ext"]["$oid"])
        json_tab << json_document
      end
    end
    if json_tab.empty? == false
      fill_db(mongo, "Fichier", json_tab, true)
      set_collection_extension(mongo, json_tab[0], key)
    end
  end
  puts "\n\n"
  mongo.debug("Fichier")
  puts "\n=============\n"
  mongo.debug("Extension")
end


# Send files to SortFile object to be sorted by their extension
#
# @parma [Array] File array to insert
# @Return [Hash] return a hash that contain files sort by extension
def send_to_sort(tab_file)
  sort = SortFile.new()
  puts tab_file
  tab_file.each do |file|
    extension = sort.get_extension(file)
    sort.sort_by_extension(file, extension)
  end
  file_hash = {}
  file_hash = sort.get_hash
end


# Clear the database, remove all files and result
#
# @param [Objetc] DbHldr object (mongo object)
def clear_database(mongo)
  mongo.rm_data(nil, "Fichier")
  mongo.rm_data(nil, "Extension")
  mongo.rm_data(nil, "Duplicate")
end

# Start the scan of the system
#
# @param [Object] Object ScanSystem
# @param [Object] Object DbHdlr (mongo object)
def scan_sys(scan, mongo)
  clear_database(mongo)
  scan.init()
  tab_file = scan.get_tab_file()
  file_hash = send_to_sort(tab_file)
  sort_insert_db(file_hash, mongo, scan)
end


scan = ScanSystem.new(ARGV[0])
mongo = DbHdlr.new()
scan_sys(scan, mongo)
