# -*- coding: utf-8 -*-

# FDF V1.1


fdfAnalysisModule do
  description {
    "This is an analysis module for CopyPeste."
  }

  author { "Team Algo" }

  usage { 'Just run it!' }

  init { Fdf.new() }

  impl {
    require 'json'
    CpRequire.modules 'analysis/fdf/use_levenshtein'
    CpRequire.modules 'analysis/fdf/check_match'
    CpRequire.libs 'modules/analysis/algorithms'
    CpRequire.libs 'modules/analysis/sort_file'
    CpRequire.libs 'database/DbHdlr'

    class Fdf
      attr_accessor :options
      attr_accessor :show

      def initialize
        @options = {
          "e" => {
            :helper => "sort by extension.",
            :allowed => [0, 1],
            :value => 0
          },
          "s" => {
            :helper => "sort by size.",
            :allowed => [0, 1],
            :value => 0
          }
        }
        @show = nil
      end

      # Put FDF results in database (collection : Duplicate)
      def put_result_in_database(mongo, data)
        data.each do |document|
          if (result = mongo.get_data("Duplicate", {:files => document["files"]})[0]) == nil
            mongo.ins_data("Duplicate", document)
          else
            mongo.ud_data({:files => document["files"]}, "Duplicate", document)
          end
        end
      end


      # Look at the different rules and chose the right way to sort files
      #
      # @param [String] rule to sort the files
      # @param [Array] Array that contain all files to sort
      # @param [Array] Array that contain all the size of the files
      # @Return [Hash] return an hash of all the files sorted
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
          when "-e-s", "-es", "-se", "-s-e"
            fichier.sort_by_extension_and_size(file, extension, size[i])
          end
          i += 1
        end
        fichier.get_hash()
      end


      # Delete the file id in the Extension collection.
      # Delete the extension document if there is no more file in it
      #
      # @param [Object] DbHldr object (mongo object)
      # @param [String] The mongo id of the file to delete
      # @param [Hash] The query to get the document in the Extension collection
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


      # Delete the file in the database and prepare to delete the file in the Extension collection
      #
      # @param [String] path of the file
      # @param [String] name of the file
      # @param [Object] DbHldr object (mongo object)
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
      end


      # Check if a file exist. if not, it will be deleted
      #
      # @param [String] file path
      # @param [String] file name
      # @param [Object] DbHldr object (mongo object)
      # @Return [Bool] return true if file exist, else return false
      def check_file_exist(path, name, mongo)
        return true if File.file?(path + "/" + name)
        delete_file_in_db(path, name, mongo)
        false
      end


      # Extract path and name of each files and concat them.
      #
      # @param [Array][Array][Hash] take an Array of Array of hash. [files by extension][one file][hash of the file]
      # @Return [Array] return a file array with the full file path :  Array[0] = /home/test/expemple.c
      def sort_tab(documents, mongo)
        files = []
        list = []
        size = []
        documents.each do |data|
          data.each do |file|
            if check_file_exist(file["path"], file["name"], mongo) == true
              list << file["path"] + "/" + file["name"]
              size << file["size"]
            end
          end
        end
        files << list << size
      end


      # Get files from the database that will be analysed
      #
      # @param [Object] DbHdlr, mongo object
      # @param [String] File extension to analyse. Nil by default (take all th file from the database).
      # @Return [Array] return a file Array with the full file path :  Array[0] = /home/test/expemple.c
      def get_doc_to_analyse(mongo, ext = nil)
        query = {}
        documents = []
        query["name"] = ext
        query = nil if ext == nil
        result = mongo.get_data("Extension", query, nil)
        result.each do |data|
          data = JSON.parse(data.to_json)
          data["_id"] = BSON::ObjectId.from_string(data["_id"]["$oid"])
          documents << mongo.get_data("Fichier", {:ext => data["_id"]})
        end
        sort_tab(documents, mongo)
      end


      # Main function of the fdf, call the sort class and the levenshtein/resync methode
      #
      # @param [Array] list of all the file who will be analyse
      # @param [String] Rules to sort files
      # @param [Array] Array of all the size for each file or nil. nil is the value by default
      # @Return [nil] return nil if there is no file to analyses
      def fdf(list, mongo, rules = nil, size = nil)
        file_hash = {}
        file_hash = sort_files_with_rules(rules, list, size)
        lev = UseLevenshtein.new(file_hash)
        lev.start()
        fdup_tab = lev.get_file_matched()
        lev_result = lev.get_levenshtein_result()
        if fdup_tab == nil
          puts "No files to analyses"
          return nil
        end
        final_data = check_files_similarity(fdup_tab, lev_result)

        put_result_in_database(mongo, final_data)
        puts "\n\n ===========Duplicates==========\n\n"
        mongo.debug("Duplicate")
      end


      # Function use to initialize and get the list of file to analyse.
      # If you want to analyse only files that have the same sizes, fdf(files[0], mongo, rules, files[1])
      # files[0] contains all files and file[1] contains all size of files
      #
      # @param [Object] DbHdlr, mongo object
      # @param [String] option (-s, -e, -se, -es, -e-s, -s-e)
      def init_fdf(mongo, rules)
        files = get_doc_to_analyse(mongo, nil)
        fdf(files[0], mongo, rules, files[1])
      end


      # For test with rules :
      # nil no sort.
      # -e sort by extension.
      # -s sort by size.
      # -se|-es|-e -s| sort by extention and size.
      def run
        @show.call "[debug] opt: #{@options}".green

        rules = ""
        @options.each do |opt, content|
          rules = rules + "-" + opt if content[:value] == 1
        end

        mongo = DbHdlr.new()
        init_fdf(mongo, rules)
      end
    end
  }

end
