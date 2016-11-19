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
    require File.join(CopyPeste::Require::Path.analysis, 'fdf/config_handler/Ignored_class')

    class Fdf
      attr_accessor :options
      attr_accessor :show

      # Module and options initialization
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
        @results = {
          module: "FDF",
          options: "List of duplicated files",
          timestamp: Time.now.getutc,
          data: []
        }
        @ignored_conf = Ignored_class.new()
      end


      # Extract path and name of each files and concat them.
      #
      # @param file [Hash] Documents retreived from the database
      # @return [Hash] nil if file has a size of 0 or a hash with usefull information otherwise
      def to_doc(file)
        return nil if file["size"] == 0
        return {
          path: file["path"] + "/" + file["name"],
          size: file["size"],
          name: file["name"]
        }
      end


      # Search for file duplication of a particular extension
      #
      # @param extension [Array] list of extensions to process
      def process(extension)
        extension["_id"] = BSON::ObjectId.from_string extension.id
        @show.call "\tRetrieving files with extension: '#{extension.name}'."
        mongo_files = FileSystem.where(ext: extension.id).not_in(name: @ignored_conf.ignored_files)
        files = []
        mongo_files.each do |file|
          doc = to_doc(file)
          files << doc if doc != nil
        end
        files.sort_by! {|file| file[:size]}
        return {} if files.length < 2
        check_files_similarity(files, extension)
      end


      # Retrieve, sort, and analyse files from database
      # Files are sorted by extension and size
      #
      # @param result [Object] result object
      def analyse(result)
        @show.call "Retrieving extensions from database..."
        extensions = Extension.not_in(name: @ignored_conf.ignored_exts).to_a
        @show.call "Done!\nSearching for duplicated files..."
        extensions = Parallel.map(extensions) do |extension|
          nb = 0
          dups = []
          process(extension).each do |key, value|
            dups << {type: "array", header: ["Files duplicated with #{key}", "percentage"], rows: value}
            nb += value.length + 1
          end
          {name: extension.name, nb: nb, dups: dups}
        end
        nb = 0
        dups_extensions = []
        extensions.each do |value|
          next if value[:dups] == []
          nb += value[:nb]
          dups_extensions.push([value[:name], value[:nb]])
          value[:dups].each { |v| result.add_array(header: v[:header], rows: v[:rows]) }
        end
        dups_extensions.sort! {|a, b| b[1] <=> a[1]}
        result.add_array(header: ["Extension", "number"], rows: dups_extensions, title: "Most duplicated extensions")
        result.add_text(text: "Total number of duplication: #{nb}")
        result.add_text(text: "Total number of files analyzed: #{FileSystem.count}")
        @show.call "Done!"
      end


      # Open files and compare their contents with the appropriate algorithm
      #
      # @param f1 [Hash] first file to compare
      # @param f2 [Hash] second file to compare
      # @return [Integer] percentage of difference between files
      def compare_files(f1, f2)
        begin
          file1 = IO.read f1[:path]
          file2 = IO.read f2[:path]
        rescue => e # file doesn't exists, db have to be updated
          @show.call "\t[Error]: #{e} Please update your database"
          return nil
        end
        # if 100% similarity and files have the same size
        if @options["p"][:value] == 100
          return nil if f1[:size] != f2[:size]
          return 100 * (Algorithms.fdupes_match(file1, f1[:size], file2, f2[:size]) + 1)
        end
        Algorithms.diff(file1, file2)
      end


      # Search for files duplicated according to user params
      #
      # @param files [Array] files to analyse
      # @param extension [Hash] Extension of the current files
      # @return [Hash] List of similar files
      def check_files_similarity(files, extension)
        duplicates = {}
        files.each_with_index do |f1, index|
          next if f1 == nil || index == files.length - 1
          ((index + 1)..(files.length - 1)).each do |j|
            next if files[j] == nil
            f2 = files[j]
            break if @options["s"][:value] == 1 && f1[:size] != f2[:size]
            next if Algorithms.levenshtein(f1[:name], f2[:name]) > @options["l"][:value]
            begin
              result = compare_files(f1, f2)
            rescue => e
              @show.call "\t[Not treated]:\n\t\t - #{f1[:path]} \n\t\t - #{f2[:path]} \n\t\t => #{e}"
            end
            next if result == nil
            f3 = f2.clone
            f3[:similarity] = result
            if (@options["p"][:value] == 100 && result == 100) || (result >= @options["p"][:value])
              # remove one of the file 100% duplicated
              # 2 files 100% duplicated will also be duplicated with other files
              # if sim(a,b) == 100 && sim(a, c) == 100 so sim(a, c) == 100
              files[j] = nil if @options["p"][:value] == 100 && result == 100
              if duplicates.key?(f1[:path])
                duplicates[f1[:path]] << [f3[:path], result]
              else
                duplicates[f1[:path]] = [[f3[:path], result]]
              end
            end
          end
        end
        @show.call "Process[#{Process.pid}]: Extension #{extension.name} processed!"
        duplicates
      end


      # Function used to initialize and run the fdf
      # Results aren't saved because it's done into the framework
      #
      # @param result [Object] results object
      def run(result)
        result.module_name = "FDF"
        result.options = @options
        analyse result
        @show.call "Done! Everything worked fine!"
        @show.call "You can now run generate_result to extract interesting informations."
      end
    end
  }
end
