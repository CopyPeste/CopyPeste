require_relative './scan_system'
require_relative '../../lib/algorithms/sort_file'
require_relative '../../lib/copy_peste/DbHdlr'
require 'mongo'
require 'json'
require 'filemagic'


# Add document into the database
#
# @param [Object] DbHdlr object
# @param [String] name of the collection to use
# @param [JSON] a json Array (tab[0] => json_document, tab[1] => json_document).
#               Or a simple json file
def fill_db(mongo, collection, json_tab)
  puts "Inserting #{json_tab.size} documents into #{collection}"
  # true for multiple insertion in db
  mongo.ins_data(collection, json_tab, true)
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
def get_extension(mongo, file, key)
  file_tab = mongo.get_data("Fichier", {ext: file["ext"]})
  document = {}
  tab_id = []
  file_tab.each do |data|
    tab_id << data["_id"]
  end
  document["_id"] = file_tab[0]["ext"]
  document["name"] = key
  document["files_id"] = tab_id
  set_extension_json(document)
end


# Insert all documents scaned into the database,
#
# @parma [Hash] a hash containing files sorted by extension
# @parma [Object] a DbHdlr object (mongo object)
# @parma [Object] a ScanSystem object
def sort_insert_db(file_hash, mongo, scan)
  extensions = []
  file_hash.each do |extension, file_array|
    json_tab = []
    ext_id = BSON::ObjectId.from_time(Time.now, unique: true)
    file_array.each do |file|
      if (file_info = scan.set_info_file(ext_id, file)) != nil        
        json_document = JSON.parse file_info
        json_document["ext"] = BSON::ObjectId.from_string(json_document["ext"]["$oid"])
        json_tab << json_document
      end
    end
    if json_tab.empty? == false
      # save all file of extension X
      fill_db(mongo, "Fichier", json_tab)
      extensions << get_extension(mongo, json_tab[0], extension)
    end
  end
  # save all extensions
  fill_db(mongo, "Extension", extensions)
end


# Send files to SortFile object to be sorted by their extension
#
# @parma [Array] File array to insert
# @Return [Hash] return a hash that contain files sort by extension
def send_to_sort(tab_file)
  sort = SortFile.new()
  tab_file.each do |file|
    extension = sort.get_extension(file)
    sort.sort_by_extension(file, extension)
  end
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
  file_hash = send_to_sort tab_file
  sort_insert_db(file_hash, mongo, scan)
end


scan = ScanSystem.new(ARGV[0])
mongo = CopyPeste::DbHdlr.new()
scan_sys(scan, mongo)
