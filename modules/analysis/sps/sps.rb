# -*- coding: utf-8 -*-

class Sps
  attr_accessor :options

  def initialize(options)
    @options = options
    @fichier = Collection.new("Fichier")
    @duplicate = Collection.new("Duplicate")
    @hash_files = {}
  end

  def start
    get_file_from_db
  end

  private 
  
  def get_file_from_db
    @hash_files = @fichier.get_doc
    sort_file
    compare_project
  end

  def compare_project
    #algo de comparaison
    save_in_db(result)
  end

  def save_in_db(result)
    in_db = @duplicate.get_doc
    result.each do |result|
      if in_db.contain(result) == false
        @duplicate.add_doc(result)
      else
        @duplicate.update_doc(result)
      end
      
  end

  def sort_file
    #ça trie le hash
  end
end
