# -*- coding: utf-8 -*-


spsAnalysisModule do
  description {
    "This is an analysis module for CopyPeste."
  }

  author { "Team Algo" }

  usage { 'Just run it!' }

  init { Sps.new() }

  impl {
    require 'json'
    require 'parallel'
    require File.join(CopyPeste::Require::Path.base, 'algorithms')
    require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')


    class Sps
      attr_accessor :options

      def initialize
        @options = {
          "test" => {
            helper: "Option de test",
            allowed: [0, 1],
            value: 0
          }  
        }
        @options = options
        #@fichier = Collection.new("Fichier")
        #@duplicate = Collection.new("Duplicate")
        @tab_files = []
        # @sort_project = SortProject.new()
        @mongo = DbHdlr.new()
      end      

      # Function called to start the Sps module
      def start
        get_file_from_db
        sort_file
        compare_projects
      end      

      # This function get the documents to analyses
      def get_file_from_db
        #@tab_files = @fichier.get_doc(nil)
        @tab_files = @mongo.get_data("Duplicate", nil, nil)
      end
      

      # This functions set the pourcent average of two projects
      #
      # @param [Array] Array containing all files similarities from two project
      # in pourcent 
      def compare_projects
        @tab_files.each do |hash_proj|
          tmp = 0
          hash_proj["diffs"].each do |nb|
            tmp = tmp + nb
          end
          hash_proj["projects similarities"] = tmp/hash_proj["diffs"].size
          hash_proj.delete("diffs")
        end

        puts @tab_files
      end

      
      # This function save the result of the compared project in the databases
      #
      # @param [String] the name of the project
      # @param [String] the name of an other project
      def save_in_db
        @tab_files.each do |hash_proj|
          if @duplicate.is_in_db?({"projects" => hash_proj["projects"]})
            @duplicate.update_doc(hash_proj)
          else
            @duplicate.add_doc(hash_proj)
          end
        end
      end

      
      # This function sort the documents by compared project:
      # tab_files[0] => {projects => [proj1, proj2], diffs => [25.0, 45.7...]}
      # tab_files[1] => {projects => [proj1, proj3], diffs => [78.0, 38.5...]}
      # etc..
      def sort_file
        tab_files = []
        @sort_project.sort_by_project(@tab_files)
        @tab_files = @sort_project.get_tab_sorted
        puts @tab_files
      end
    end

    
    # Function used to initialize and run the fdf
    def run(*)
      analyse
      @mongo.ins_data(@c_res, @results)
      @show.call "Done! Everything worked fine!"
      @show.call "You can now run generate_result to extract interesting informations."
    end
 
  }
end
