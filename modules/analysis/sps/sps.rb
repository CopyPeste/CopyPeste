# -*- coding: utf-8 -*-

require_relative './collection'
require_relative '../../../libs/modules/analysis/sort_project'

class Sps
  attr_accessor :options

  def initialize(options)
    @options = options
    #@fichier = Collection.new("Fichier")
    #@duplicate = Collection.new("Duplicate")
    @hash_files = {}
    @sort_project = SortProject.new()
  end

  def start
    get_file_from_db
  end

  private 
  
  def get_file_from_db
    @hash_files = {:files => ["/projet3/path...etc", "/projet2/path...etc",
                              "/projet1/path...etc","/projet3/path...etc",
                              "/projet2/path...etc","/projet1/path...etc",
                              "/projet1/path...etc", ]}
    #@hash_files = @fichier.get_doc
    sort_file
    #compare_project
  end

  def compare_project
    #algo de comparaison
    #save_in_db(result)
  end

  def save_in_db(result)
    # in_db = @duplicate.get_doc
    # result.each do |result|
    #   if in_db.contain(result) == false
    #     @duplicate.add_doc(result)
    #   else
    #     @duplicate.update_doc(result)
    #   end
      
  end

  def sort_file
    @sort_project.sort_by_project(@hash_files)
    @hash_files = @sort_project.get_hash_sorted
    puts @hash_files
  end
end
