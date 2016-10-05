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
    require 'parallel'
    require File.join(CopyPeste::Require::Path.base, 'algorithms')
    require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')
    require File.join(CopyPeste::Require::Path.analysis, 'fdf/config_handler/Ignored_class')

    class Fdf
      attr_accessor :options
      attr_accessor :show


      def initialize
        @options = {
          "l" => {
            helper: "Minimum levenshtein distance",
            allowed: [*0..10],
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
          rows: {}
        }
        @ignored_conf = Ignored_class.new()
      end


      # Extract path and name of each files and concat them.
      #
      # @param [Hash] file document from the database
      # @Return [Hash] nil if file has a size of 0 or a hash with usefull information otherwise
      def to_doc(file)
        return nil if file["size"] == 0
        return {
          path: file["path"] + "/" + file["name"],
          size: file["size"],
          name: file["name"]
        }
      end


      #
      #
      #
      def process(extension)
        extension["_id"] = BSON::ObjectId.from_string extension["_id"]["$oid"]
        @show.call "\tRetrieving files with extension: '#{extension["name"]}'."
        query = {ext: extension["_id"], name: {"$nin" => @ignored_conf.ignored_files }}
        mongo_files = @mongo.get_data(@c_file, query)
        files = []
        mongo_files.each do |file|
          doc = to_doc(file)
          files << doc if doc != nil
        end
        files.sort_by! {|file| file[:size]}
        return if files.length < 2
        check_files_similarity(files, extension)
      end


      # Retrieve and sort files from database
      # FIles are sorted by extension and by size
      #
      # @Return [Hash] Each entry is a file extension that maps to an array of files order by size
      def get_doc_to_analyse
        query = {name: {"$nin" => @ignored_conf.ignored_exts}}
        extensions = @mongo.get_data("Extension", query, nil)
        return if extensions.length == 0
        Parallel.map(extensions, in_processes: 4) { |extension| process extension }
      end


      # Open files and compare their contents with the appropriate algorithm
      #
      # @param [Hash] f1 represents the first file
      # @param [Hash] f2 represents the second file
      # @return [Integer] Return the percentage of difference between files
      def compare_files(f1, f2)
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


      # Search for files duplicated according to user params
      #
      # @param [Hash] Each entry is a file extension that maps to an array of files order by size
      def check_files_similarity(files, extension)
        files.each_with_index do |f1, index|
          next if f1 == nil || index == files.length - 1
          ((index + 1)..(files.length - 1)).each do |j|
            next if files[j] == nil
            f2 = files[j]
            break if @options["s"][:value] == 1 && f1[:size] != f2[:size]
            next if Algorithms.levenshtein(f1[:name], f2[:name]) > @options["l"][:value]
            result = compare_files(f1, f2)
            next if result == nil
            f3 = f2.clone
            f3[:similarity] = result
            if (@options["p"][:value] == 100 && result == 100) || (result >= @options["p"][:value])
              # remove one of the file 100% duplicated
              # 2 files 100% duplicated will also be duplicated with other files
              # if sim(a,b) == 100 && sim(a, c) == 100 so sim(a, c) == 100
              files[j] = nil if @options["p"][:value] == 100 && result == 100
              if @results[:rows].key?(f1[:path])
                @results[:rows][f1[:path]] << f3
              else
                @results[:rows][f1[:path]] = [f3]
              end
            end
          end
        end
        puts "Process[#{Process.pid}]: Extension #{extension["name"]} processed!"
      end


      # Function used to initialize and run the fdf
      def run(*)
        @show.call "Get all files from database..."
        get_doc_to_analyse
        exit(0)
        @show.call "Done."
        @show.call "Saving analyse results in database..."
        puts @results[:rows].keys.length
        @mongo.ins_data(@c_res, @results)
        @show.call "Done, everything worked fine!"
        @show.call "You can now run generate_result to extract interesting informations."
      end
    end
  }
end
