# -*- coding: utf-8 -*-

# FDF V1.3

fdfAnalysisModule do
  description {
    "This is an analysis module for CopyPeste."
  }

  author { "Team Algo" }

  usage { 'Just run it!' }

  init { Fdf.new() }

  impl {
    require 'json'
    require File.join(CopyPeste::Require::Path.base, 'algorithms')
    require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')
    require File.join(CopyPeste::Require::Path.analysis, 'fdf/config_handler/Ignored_class')
    
    class Fdf
      attr_accessor :options
      attr_accessor :show
      

      def initialize
        @options = {
          "e" => {
            helper: "sort by extension.",
            allowed: [0, 1],
            value: 1
          },
          "s" => {
            helper: "sort by size.",
            allowed: [0, 1],
            value: 1
          },
          "p" => {
            helper: "minimum percentage of similarity between 2 files",
            allowed: [*60..100],
            value: 100
          }
        }
        @mongo = DbHdlr.new()
        @c_res = "Scoring"
        @c_file = "Fichier"
        @results = {
          module: "FDF",
          options: "List of duplicated files",
          timestamp: Time.now.getutc,
          type: "array",
          header: ["first", "second", "score"],
          references: [@c_file, @c_file, nil],
          transformation: [],
          rows: []
        }
        @ignored_conf = Ignored_class.new()
      end


      # Look at the different rules and chose the right way to sort files
      #
      # @param [Array] Array of files to sort
      # @Return [Hash] return an hash of all the files sorted
      def sort_files_with_rules(documents)
        documents.each do |extension, files|
          @show.call "\tSorting extension '#{extension}' per size."
          files.sort_by {|file| file[:value]}
          documents[extension] = files
        end
        documents
      end


      # Extract path and name of each files and concat them.
      #
      # @param [Array][Array][Hash] take an Array of Array of hash. [files by extension][one file][hash of the file]
      # @Return [Array] return a file array with their full path and size
      def to_doc(file)
        return nil if file["size"] == 0
        return {
          path: file["path"] + "/" + file["name"],
          size: file["size"],
          name: file["name"]
        }
      end


      # Get files from the database that will be analysed
      #
      # @Return [Array] return a file Array with the full file path :  Array[0] = /home/test/expemple.c
      def get_doc_to_analyse
        documents = {}
        query = {name: {"$nin" => @ignored_conf.ignored_ext}}
        # get all extensions
        extensions = @mongo.get_data("Extension", query, nil)
        # for each extension
        extensions.each do |extension|
          extension["_id"] = BSON::ObjectId.from_string extension["_id"]["$oid"]
          @show.call "\tRetrieving files with extension: '#{extension["name"]}'."
          query = {ext: extension["_id"], name: {"$nin" => @ignored_conf.ignored_files }}
          # get all corresponding files
          files = @mongo.get_data(@c_file, query)
          documents[extension["name"]] = []
          # save each file, formated, in the good extension
          files.each do |file|
            doc = to_doc(file)
            documents[extension["name"]] << doc if doc != nil
          end
        end
        documents
      end


      # Save pair of file compared by fdupes/levenshtein, and there result
      # This Hash is saved in an Array
      #
      # @param [Hash] files and distance between their titles
      # @param [Int] result of comparison algorim
      # @return
      def save_result_data(file_d, similarity)
        result_data = [
          file_d[:files][0], #first file
          file_d[:files][1], #second file
          similarity #their similarity score
        ]
        @results[:rows] << result_data
      end


      # Open the two files and send there containt to fdupes algorithm
      #
      # @param [Array] File Array
      # @param [Integer] Loop position
      # @return [Integer] Return the percentage of difference between files
      def open_and_send(f1, f2)
        begin
          file1 = IO.read f1[:path]
          file2 = IO.read f2[:path]
        rescue => e # file doesn't exists, db have to be updated
          @show.call "\t[Error]: #{e} Please update your database"
          return nil
        end
        begin
          # if 100% similarity and files have the same size
          if @options["p"][:value] == 100
            return nil if f1[:size] != f2[:size]
            return 100 * (Algorithms.fdupes_match(file1, f1[:size], file2, f2[:size]) + 1)
          end
          Algorithms.diff(file1, file2)
        rescue => e
          @show.call "\t[Not treated]: #{f1[:path]} & #{f2[:path]}: #{e}"
        end
      end


      # Send files to the fdupes algorithms
      # 
      # @param [Array] File array containing levenshtein's results
      def check_files_similarity(documents)
        duplicated_files = {}
        # for each extension
        documents.each do |extension, files|
          next if files.length < 2
          @show.call "\tSearching for duplication with extension: '#{extension}'."
          # iterate all files to find duplications
          (files.length - 1).times do |i|
            f1 = files[i]
            #@show.call "\tSearching if file #{f1[:name]} is duplicated"
            ((i + 1)..(files.length - 1)).each do |j|
              f2 = files[j]
              # stop loop if size is required but files aren't of the same size
              break if @options["s"][:value] == 1 && f1[:size] != f2[:size]
              # allow little differences in filenames
              next if Algorithms.levenshtein(f1[:name], f2[:name]) > 1
              result = open_and_send(f1, f2)
              next if result == nil
              f3 = f2.clone
              f3[:similarity] = result
              if (@options["p"][:value] == 100 && result == 100) || (result >= @options["p"][:value])
                if duplicated_files.key?(f1[:path])
                  duplicated_files[f1[:path]] << f3
                else
                  duplicated_files[f1[:path]] = [f3]
                end
              end
            end
          end
        end
        @results[:rows] = duplicated_files
      end


      # Function used to initialize and run the fdf
      # and get the list of file to analyse.
      def run(*)
        @show.call "Get all files from database..."
        files = get_doc_to_analyse
        @show.call "Done."
        @show.call "Sort files depending on options..."
        sorted_file = sort_files_with_rules files
        @show.call "Done."
        @show.call "Searching for duplicated files..."
        check_files_similarity sorted_file
        @show.call "Done."
        @show.call "Saving analyse results in database..."
        @mongo.ins_data(@c_res, @results)
        @show.call "Done, everything worked fine!"
        @show.call "You can now run generate_result to extract interesting informations."
      end
    end
  }
end
