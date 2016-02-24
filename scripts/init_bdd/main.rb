require './ScanSystem'
require './SortFile'
require './MongoDb'
require './DbHdlr'
require 'mongo'
require 'json'

def mongoDb(mongo)
#  mongo.initMongo(nil)
#  mongo.creatDB("MongoJeTest30")
#  mongo.creatCollection("Fichier")
end

def fill_db(mongo, collection, json_tab, multifile)
  mongo.ins_data(collection, json_tab, multifile)
end

def set_extension_json(document)
  tab = Array.new
  json_document = JSON.parse(document.to_json)
  json_document["_id"] = BSON::ObjectId.from_string(document['_id']['$oid'])
  (json_document["files_id"]).each do |data|
    data = BSON::ObjectId.from_string(data["$oid"])
    tab << data
  end
  json_document["files_id"] = tab
  return json_document
end

def set_collection_extension(mongo, file, key)
  file_tab = mongo.get_document("Fichier", "ext", file["ext"])
  document = Hash.new
  tab_id = Array.new
  file_tab.each do |data|
    tab_id << data["_id"]
  end
  document["_id"] = file_tab[0]["ext"]
  document["name"] = key
  document["files_id"] = tab_id
  json_document = set_extension_json(document)
  fill_db(mongo, "Extension", json_document, false)
end

def sort_insert_db(fileHash, mongo, scan)
  fileHash.each do |key, value|
    json_tab = Array.new
    ext_id = BSON::ObjectId.from_time(Time.now, unique: true)
    value.each do |file|
      json_document = scan.set_info_file(ext_id, file)
      json_document = JSON.parse(json_document)
      json_document["ext"] = BSON::ObjectId.from_string(json_document['ext']['$oid'])
      json_tab << json_document
    end
    fill_db(mongo, "Fichier", json_tab, true)
    set_collection_extension(mongo, json_tab[0], key)
  end
  puts "\n\n"
  mongo.debug("Fichier")
  puts "\n===================================================================================\n"
  mongo.debug("Extension")
end

def scanSys(scan, mongo)
  scan.init()
  scan.sendToSort()
  fileHash = scan.getSortFile()
  mongoDb(mongo)
  sort_insert_db(fileHash, mongo, scan)
end

scan = ScanSystem.new("/home/edouard/test")
#mongo = MongoDb.new("127.0.0.1", "27017")
mongo = DbHdlr.new()

scanSys(scan, mongo)
